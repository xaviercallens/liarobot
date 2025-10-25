#!/bin/bash

echo "🔍 Testing Sonatype Central API Access"
echo "====================================="

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

print_info "Testing Central API connectivity and authentication..."

# Test 1: Basic API connectivity
print_info "Test 1: API Connectivity"
echo "========================"
API_HEALTH=$(curl -s -w "%{http_code}" -o /tmp/api_response "$CENTRAL_API_BASE/publisher/deployments" -u "$USERNAME:$PASSWORD")

if [ "$API_HEALTH" = "200" ]; then
    print_status "API accessible (HTTP 200)"
    print_info "Response:"
    cat /tmp/api_response | jq . 2>/dev/null || cat /tmp/api_response
elif [ "$API_HEALTH" = "401" ]; then
    print_error "Authentication failed (HTTP 401)"
    print_info "Credentials may be incorrect or account needs verification"
elif [ "$API_HEALTH" = "403" ]; then
    print_error "Access forbidden (HTTP 403)"
    print_info "Account may not have publishing permissions"
else
    print_warning "Unexpected response (HTTP $API_HEALTH)"
    print_info "Response:"
    cat /tmp/api_response
fi

echo ""

# Test 2: Check user info/profile
print_info "Test 2: User Profile"
echo "===================="
USER_INFO=$(curl -s -w "%{http_code}" -o /tmp/user_response "$CENTRAL_API_BASE/publisher/profile" -u "$USERNAME:$PASSWORD")

if [ "$USER_INFO" = "200" ]; then
    print_status "User profile accessible"
    print_info "Profile info:"
    cat /tmp/user_response | jq . 2>/dev/null || cat /tmp/user_response
else
    print_warning "User profile not accessible (HTTP $USER_INFO)"
    cat /tmp/user_response
fi

echo ""

# Test 3: Check namespaces/permissions
print_info "Test 3: Namespace Permissions"
echo "============================="
NAMESPACES=$(curl -s -w "%{http_code}" -o /tmp/namespaces_response "$CENTRAL_API_BASE/publisher/namespaces" -u "$USERNAME:$PASSWORD")

if [ "$NAMESPACES" = "200" ]; then
    print_status "Namespaces accessible"
    print_info "Available namespaces:"
    cat /tmp/namespaces_response | jq . 2>/dev/null || cat /tmp/namespaces_response
    
    # Check if org.amcp is available
    if cat /tmp/namespaces_response | grep -q "org.amcp"; then
        print_status "org.amcp namespace is available!"
    else
        print_warning "org.amcp namespace not found in available namespaces"
    fi
else
    print_warning "Namespaces not accessible (HTTP $NAMESPACES)"
    cat /tmp/namespaces_response
fi

echo ""

# Test 4: API Documentation endpoints
print_info "Test 4: Available API Endpoints"
echo "==============================="
print_info "Central API Base: $CENTRAL_API_BASE"
print_info "Key endpoints:"
echo "  - Deployments: $CENTRAL_API_BASE/publisher/deployments"
echo "  - Upload: $CENTRAL_API_BASE/publisher/upload"
echo "  - Publish: $CENTRAL_API_BASE/publisher/publish"
echo "  - Status: $CENTRAL_API_BASE/publisher/status"
echo "  - Profile: $CENTRAL_API_BASE/publisher/profile"
echo "  - Namespaces: $CENTRAL_API_BASE/publisher/namespaces"

echo ""

# Test 5: Check if jq is available for JSON parsing
print_info "Test 5: JSON Processing"
echo "======================="
if command -v jq &> /dev/null; then
    print_status "jq is available for JSON processing"
else
    print_warning "jq not found - installing for better JSON handling..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y jq
    elif command -v yum &> /dev/null; then
        sudo yum install -y jq
    else
        print_info "Please install jq manually for better JSON processing"
    fi
fi

echo ""

# Summary
print_info "API TEST SUMMARY"
echo "================"
print_info "API Base URL: $CENTRAL_API_BASE"
print_info "Username: $USERNAME"
print_info "Authentication: $([ "$API_HEALTH" = "200" ] && echo "✅ SUCCESS" || echo "❌ FAILED")"

if [ "$API_HEALTH" = "200" ]; then
    print_status "🎉 Central API is accessible! Ready for deployment."
    print_info "You can now run: ./deploy-central-api.sh"
else
    print_error "❌ API access issues detected."
    print_info "Possible solutions:"
    echo "1. Verify credentials are correct"
    echo "2. Check if account has Central Portal access"
    echo "3. Ensure org.amcp namespace is approved"
    echo "4. Try the web interface: https://central.sonatype.com/"
fi

# Cleanup
rm -f /tmp/api_response /tmp/user_response /tmp/namespaces_response

print_status "API testing completed!"
