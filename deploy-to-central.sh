#!/bin/bash

echo "🚀 Deploying AMCP Core v1.5.0 to Maven Central"
echo "=============================================="

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

# Check prerequisites
print_info "Checking prerequisites..."

if [ ! -f ~/.m2/settings.xml ]; then
    print_error "Maven settings.xml not found!"
    print_info "Please configure ~/.m2/settings.xml with your Sonatype credentials"
    print_info "Use the template: ~/.m2/settings-central-template.xml"
    exit 1
fi

if ! gpg --list-secret-keys | grep -q "sec"; then
    print_error "No GPG secret key found!"
    print_info "Please generate a GPG key first using: ./generate-gpg-key.sh"
    exit 1
fi

print_status "Prerequisites check passed"

# Navigate to project directory
cd amcp-core-project

# Use the Maven Central POM
cp pom-central.xml pom.xml

print_info "Building and signing artifacts..."

# Clean and build
mvn clean compile test

if [ $? -ne 0 ]; then
    print_error "Build failed"
    exit 1
fi

print_status "Build successful"

# Deploy to staging repository
print_info "Deploying to Maven Central staging repository..."

mvn deploy -P ossrh

if [ $? -eq 0 ]; then
    print_status "🎉 Deployment to staging successful!"
    echo ""
    print_info "Next steps:"
    echo "1. Go to: https://s01.oss.sonatype.org/"
    echo "2. Login with your Sonatype credentials"
    echo "3. Go to 'Staging Repositories'"
    echo "4. Find your org.amcp repository"
    echo "5. Select it and click 'Close'"
    echo "6. Wait for validation to complete"
    echo "7. Click 'Release' to publish to Maven Central"
    echo ""
    print_info "After release, artifacts will be available at:"
    echo "  https://repo1.maven.org/maven2/org/amcp/amcp-core/1.5.0/"
    echo ""
    print_warning "Note: It can take 2-4 hours for artifacts to appear in Maven Central"
else
    print_error "Deployment failed"
    print_info "Check the error messages above and verify:"
    echo "1. Sonatype credentials are correct"
    echo "2. GPG key is properly configured"
    echo "3. All required artifacts are signed"
fi
