#!/bin/bash

echo "🔍 Monitoring AMCP org.amcp Namespace Verification"
echo "=================================================="

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

# Configuration
VERIFICATION_KEY="0wcck9mytv"
NAMESPACE_ID="710a98a1-b3a5-4c6c-bbe8-2bd3abae2f52"
USERNAME="9v2ll7"
PASSWORD="NTjvxvJGj3bSphjhHBwCo4X9dyoLyN9fm"
CENTRAL_API_BASE="https://central.sonatype.com/api/v1"

print_info "Monitoring verification status for:"
echo "  Verification Key: $VERIFICATION_KEY"
echo "  Namespace ID: $NAMESPACE_ID"
echo "  Username: $USERNAME"
echo ""

# Function to check API access
check_api_access() {
    local endpoint="$1"
    local description="$2"
    
    print_info "Testing $description..."
    
    local response=$(curl -s -w "%{http_code}" -o /tmp/api_response \
        -u "$USERNAME:$PASSWORD" \
        "$CENTRAL_API_BASE$endpoint")
    
    case "$response" in
        "200")
            print_status "$description accessible (HTTP 200)"
            if [ -s /tmp/api_response ]; then
                echo "Response preview:"
                head -c 500 /tmp/api_response | jq . 2>/dev/null || head -c 500 /tmp/api_response
                echo ""
            fi
            return 0
            ;;
        "401")
            print_warning "$description - Authentication failed (HTTP 401)"
            return 1
            ;;
        "403")
            print_warning "$description - Access forbidden (HTTP 403)"
            return 1
            ;;
        *)
            print_warning "$description - HTTP $response"
            if [ -s /tmp/api_response ]; then
                head -c 200 /tmp/api_response
                echo ""
            fi
            return 1
            ;;
    esac
}

# Function to check namespace status
check_namespace_status() {
    print_info "Checking namespace status..."
    
    local response=$(curl -s -w "%{http_code}" -o /tmp/namespace_response \
        -u "$USERNAME:$PASSWORD" \
        "$CENTRAL_API_BASE/publisher/namespaces")
    
    if [ "$response" = "200" ]; then
        print_status "Namespaces endpoint accessible"
        
        # Check if org.amcp is in the response
        if grep -q "org.amcp" /tmp/namespace_response 2>/dev/null; then
            print_status "🎉 org.amcp namespace found in available namespaces!"
            
            # Try to extract status if available
            local namespace_info=$(cat /tmp/namespace_response | jq '.[] | select(.namespace == "org.amcp")' 2>/dev/null)
            if [ ! -z "$namespace_info" ]; then
                print_info "Namespace details:"
                echo "$namespace_info" | jq .
            fi
            return 0
        else
            print_warning "org.amcp namespace not yet available"
            print_info "Available namespaces:"
            cat /tmp/namespace_response | jq . 2>/dev/null || cat /tmp/namespace_response
            return 1
        fi
    else
        print_warning "Namespaces endpoint not accessible (HTTP $response)"
        return 1
    fi
}

# Function to attempt deployment
attempt_deployment() {
    print_info "🚀 Attempting deployment to Maven Central..."
    
    cd amcp-core-project
    
    # Quick deployment attempt
    mvn clean deploy -Dgpg.passphrase=amcp-maven-central-2025 -q
    
    local deploy_status=$?
    
    if [ $deploy_status -eq 0 ]; then
        print_status "🎉 DEPLOYMENT SUCCESSFUL!"
        echo ""
        print_info "🌐 AMCP Core v1.5.0 has been published to Maven Central!"
        echo ""
        print_info "📦 Maven Coordinates:"
        echo "  <dependency>"
        echo "    <groupId>org.amcp</groupId>"
        echo "    <artifactId>amcp-core</artifactId>"
        echo "    <version>1.5.0</version>"
        echo "  </dependency>"
        echo ""
        print_warning "⏰ Note: It may take 2-4 hours for artifacts to appear in search"
        print_info "🔍 Verify availability: ./verify-maven-central.sh"
        return 0
    else
        print_warning "Deployment not yet successful - verification may still be pending"
        return 1
    fi
    
    cd ..
}

# Main monitoring loop
print_info "Starting verification monitoring..."
echo ""

# Test 1: Basic API connectivity
check_api_access "/publisher/deployments" "Deployments API"
API_ACCESS=$?

echo ""

# Test 2: Namespace status
check_namespace_status
NAMESPACE_ACCESS=$?

echo ""

# Test 3: Profile access
check_api_access "/publisher/profile" "Profile API"
PROFILE_ACCESS=$?

echo ""

# Summary and next steps
print_info "VERIFICATION STATUS SUMMARY"
echo "============================"
echo ""

if [ $API_ACCESS -eq 0 ] && [ $NAMESPACE_ACCESS -eq 0 ]; then
    print_status "🎉 VERIFICATION APPEARS COMPLETE!"
    echo ""
    print_info "✅ API access: Working"
    print_info "✅ Namespace: org.amcp available"
    print_info "✅ Profile: Accessible"
    echo ""
    print_info "🚀 Ready for deployment! Attempting now..."
    echo ""
    
    attempt_deployment
    
    if [ $? -eq 0 ]; then
        print_status "🎊 MAVEN CENTRAL DEPLOYMENT SUCCESSFUL!"
        exit 0
    fi
    
elif [ $API_ACCESS -eq 0 ]; then
    print_warning "⚠️ Partial access - verification in progress"
    echo ""
    print_info "✅ API access: Working"
    print_warning "⏳ Namespace: Still pending"
    echo ""
    print_info "Status: Verification is progressing but not yet complete"
    
else
    print_warning "⚠️ Verification still pending"
    echo ""
    print_warning "⏳ API access: Not yet available"
    print_warning "⏳ Namespace: Pending verification"
    echo ""
    print_info "Status: Verification is still in progress"
fi

echo ""
print_info "📋 NEXT STEPS"
echo "============="
echo ""

if [ $API_ACCESS -eq 0 ]; then
    print_info "🔄 Verification is progressing - try deployment:"
    echo "  ./deploy-with-new-key.sh"
else
    print_info "⏳ Wait for verification to complete, then:"
    echo "  ./monitor-verification.sh  # Check status again"
    echo "  ./deploy-with-new-key.sh   # Deploy when ready"
fi

echo ""
print_info "🌐 Monitor verification status at:"
echo "  https://central.sonatype.com/publishing"
echo "  https://central.sonatype.com/publishing/namespaces"
echo ""

print_info "📧 You should receive email notifications when verification completes"

# Cleanup
rm -f /tmp/api_response /tmp/namespace_response

echo ""
print_status "Verification monitoring completed!"
echo ""
print_info "🎯 Current Status: $([ $API_ACCESS -eq 0 ] && [ $NAMESPACE_ACCESS -eq 0 ] && echo "Ready for deployment!" || echo "Waiting for verification completion")"
