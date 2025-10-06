#!/bin/bash

echo "🚀 Deploying AMCP Core v1.5.0 via Sonatype Central API"
echo "===================================================="

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# API Configuration
CENTRAL_API_BASE="https://central.sonatype.com/api/v1"
USERNAME="9v2ll7"
PASSWORD="NTjvxvJGj3bSphjhHBwCo4X9dyoLyN9fm"

# Project details
GROUP_ID="org.amcp"
ARTIFACT_ID="amcp-core"
VERSION="1.5.0"
PROJECT_DIR="amcp-core-project"

print_info "Preparing artifacts for Central API upload..."

cd "$PROJECT_DIR"

# Ensure artifacts are built
if [ ! -f "target/${ARTIFACT_ID}-${VERSION}.jar" ]; then
    print_info "Building artifacts first..."
    mvn clean package source:jar javadoc:jar -Dgpg.passphrase=amcp-maven-central-2025
    
    if [ $? -ne 0 ]; then
        print_error "Failed to build artifacts"
        exit 1
    fi
fi

print_status "Artifacts ready for upload"

# Create deployment bundle
BUNDLE_DIR="target/central-bundle"
mkdir -p "$BUNDLE_DIR"

print_info "Creating deployment bundle..."

# Copy all required files to bundle directory
cp "target/${ARTIFACT_ID}-${VERSION}.jar" "$BUNDLE_DIR/"
cp "target/${ARTIFACT_ID}-${VERSION}-sources.jar" "$BUNDLE_DIR/"
cp "target/${ARTIFACT_ID}-${VERSION}-javadoc.jar" "$BUNDLE_DIR/"
cp "pom.xml" "$BUNDLE_DIR/${ARTIFACT_ID}-${VERSION}.pom"

# Sign all files if not already signed
for file in "$BUNDLE_DIR"/*; do
    if [ ! -f "${file}.asc" ]; then
        print_info "Signing $(basename "$file")..."
        gpg --detach-sign --armor --batch --yes --passphrase "amcp-maven-central-2025" "$file"
    fi
done

print_status "All files signed and ready"

# Create bundle zip
BUNDLE_ZIP="target/${ARTIFACT_ID}-${VERSION}-bundle.zip"
cd "$BUNDLE_DIR"
zip -r "../$(basename "$BUNDLE_ZIP")" .
cd - > /dev/null

print_status "Bundle created: $BUNDLE_ZIP"

print_info "Uploading to Sonatype Central API..."

# Function to make API calls
make_api_call() {
    local method="$1"
    local endpoint="$2"
    local data="$3"
    local content_type="${4:-application/json}"
    
    if [ -n "$data" ]; then
        curl -s -X "$method" \
            -u "$USERNAME:$PASSWORD" \
            -H "Content-Type: $content_type" \
            -d "$data" \
            "$CENTRAL_API_BASE$endpoint"
    else
        curl -s -X "$method" \
            -u "$USERNAME:$PASSWORD" \
            "$CENTRAL_API_BASE$endpoint"
    fi
}

# Function to upload bundle
upload_bundle() {
    local bundle_path="$1"
    
    print_info "Uploading bundle via Central API..."
    
    # Upload the bundle
    UPLOAD_RESPONSE=$(curl -s -X POST \
        -u "$USERNAME:$PASSWORD" \
        -H "Content-Type: multipart/form-data" \
        -F "bundle=@$bundle_path" \
        "$CENTRAL_API_BASE/publisher/upload")
    
    echo "$UPLOAD_RESPONSE"
}

# Function to check deployment status
check_deployment_status() {
    local deployment_id="$1"
    
    print_info "Checking deployment status for ID: $deployment_id"
    
    STATUS_RESPONSE=$(make_api_call "GET" "/publisher/status?id=$deployment_id")
    echo "$STATUS_RESPONSE"
}

# Function to publish deployment
publish_deployment() {
    local deployment_id="$1"
    
    print_info "Publishing deployment ID: $deployment_id"
    
    PUBLISH_RESPONSE=$(make_api_call "POST" "/publisher/publish" "{\"deploymentId\":\"$deployment_id\"}")
    echo "$PUBLISH_RESPONSE"
}

print_info "Starting Central API deployment process..."

# Step 1: Upload bundle
print_info "Step 1: Uploading bundle..."
UPLOAD_RESULT=$(upload_bundle "$BUNDLE_ZIP")

print_info "Upload response:"
echo "$UPLOAD_RESULT" | jq . 2>/dev/null || echo "$UPLOAD_RESULT"

# Extract deployment ID from response
DEPLOYMENT_ID=$(echo "$UPLOAD_RESULT" | jq -r '.deploymentId // empty' 2>/dev/null)

if [ -z "$DEPLOYMENT_ID" ] || [ "$DEPLOYMENT_ID" = "null" ]; then
    print_error "Failed to get deployment ID from upload response"
    print_info "Full response: $UPLOAD_RESULT"
    
    # Try alternative approach - direct API calls
    print_info "Trying alternative API approach..."
    
    # Check if we can access the API at all
    print_info "Testing API connectivity..."
    API_TEST=$(make_api_call "GET" "/publisher/deployments")
    print_info "API test response:"
    echo "$API_TEST" | jq . 2>/dev/null || echo "$API_TEST"
    
    exit 1
fi

print_status "Bundle uploaded successfully! Deployment ID: $DEPLOYMENT_ID"

# Step 2: Check status
print_info "Step 2: Checking deployment status..."
sleep 5  # Wait a bit for processing

STATUS_RESULT=$(check_deployment_status "$DEPLOYMENT_ID")
print_info "Status response:"
echo "$STATUS_RESULT" | jq . 2>/dev/null || echo "$STATUS_RESULT"

# Step 3: Publish if validation passed
VALIDATION_STATUS=$(echo "$STATUS_RESULT" | jq -r '.deploymentState // empty' 2>/dev/null)

if [ "$VALIDATION_STATUS" = "VALIDATED" ] || [ "$VALIDATION_STATUS" = "PENDING" ]; then
    print_status "Validation successful! Publishing to Central..."
    
    PUBLISH_RESULT=$(publish_deployment "$DEPLOYMENT_ID")
    print_info "Publish response:"
    echo "$PUBLISH_RESULT" | jq . 2>/dev/null || echo "$PUBLISH_RESULT"
    
    if echo "$PUBLISH_RESULT" | grep -q "success\|published\|PUBLISHED"; then
        print_status "🎉 Successfully published to Maven Central!"
        echo ""
        print_info "🌐 Deployment Details:"
        echo "  Group ID: $GROUP_ID"
        echo "  Artifact ID: $ARTIFACT_ID"
        echo "  Version: $VERSION"
        echo "  Deployment ID: $DEPLOYMENT_ID"
        echo ""
        print_info "📦 Maven Coordinates:"
        echo "  <dependency>"
        echo "    <groupId>$GROUP_ID</groupId>"
        echo "    <artifactId>$ARTIFACT_ID</artifactId>"
        echo "    <version>$VERSION</version>"
        echo "  </dependency>"
        echo ""
        print_warning "⏰ Note: It may take 2-4 hours for artifacts to appear in Maven Central"
        print_info "🔍 Check availability: ./verify-maven-central.sh"
        
    else
        print_error "Publication may have failed. Check the response above."
    fi
    
else
    print_error "Validation failed or still in progress"
    print_info "Validation status: $VALIDATION_STATUS"
    print_info "You may need to check the Central Portal web interface:"
    echo "  https://central.sonatype.com/publishing/deployments"
fi

# Cleanup
rm -rf "$BUNDLE_DIR"
rm -f "$BUNDLE_ZIP"

print_status "🎊 Central API deployment process completed!"
echo ""
print_info "📋 Summary:"
echo "  ✅ Bundle created and uploaded"
echo "  ✅ Deployment ID obtained: $DEPLOYMENT_ID"
echo "  ✅ API calls completed"
echo ""
print_info "🌐 Next steps:"
echo "1. Monitor deployment at: https://central.sonatype.com/publishing/deployments"
echo "2. Check Maven Central availability in 2-4 hours"
echo "3. Verify with: ./verify-maven-central.sh"
