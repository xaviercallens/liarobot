#!/bin/bash

echo "🔍 Verifying AMCP Core v1.5.0 GitHub Release"
echo "============================================"

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

# URLs to verify
BASE_URL="https://github.com/agentmeshcommunicationprotocol/amcpcore.github.io/releases"
LATEST_URL="${BASE_URL}/latest"
VERSION_URL="${BASE_URL}/tag/v1.5.0"

JAR_URL="${BASE_URL}/latest/download/amcp-core-1.5.0.jar"
SOURCES_URL="${BASE_URL}/latest/download/amcp-core-1.5.0-sources.jar"
JAVADOC_URL="${BASE_URL}/latest/download/amcp-core-1.5.0-javadoc.jar"

print_info "Verifying GitHub release accessibility..."
echo ""

# Test 1: Check if release page exists
print_info "Test 1: Release Page Accessibility"
echo "=================================="
RELEASE_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$VERSION_URL")

if [ "$RELEASE_STATUS" -eq 200 ]; then
    print_status "Release page accessible (HTTP $RELEASE_STATUS)"
    echo "URL: $VERSION_URL"
else
    print_error "Release page not accessible (HTTP $RELEASE_STATUS)"
    echo "URL: $VERSION_URL"
fi
echo ""

# Test 2: Check latest release redirect
print_info "Test 2: Latest Release Redirect"
echo "==============================="
LATEST_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$LATEST_URL")

if [ "$LATEST_STATUS" -eq 200 ]; then
    print_status "Latest release redirect working (HTTP $LATEST_STATUS)"
    echo "URL: $LATEST_URL"
else
    print_error "Latest release redirect not working (HTTP $LATEST_STATUS)"
    echo "URL: $LATEST_URL"
fi
echo ""

# Test 3: Verify JAR download
print_info "Test 3: JAR File Download"
echo "========================="
JAR_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$JAR_URL")

if [ "$JAR_STATUS" -eq 200 ]; then
    print_status "Main JAR downloadable (HTTP $JAR_STATUS)"
    echo "URL: $JAR_URL"
    
    # Get file size
    JAR_SIZE=$(curl -s -I "$JAR_URL" | grep -i content-length | awk '{print $2}' | tr -d '\r')
    if [ ! -z "$JAR_SIZE" ]; then
        JAR_SIZE_KB=$((JAR_SIZE / 1024))
        print_info "JAR size: ${JAR_SIZE_KB} KB"
    fi
else
    print_error "Main JAR not downloadable (HTTP $JAR_STATUS)"
    echo "URL: $JAR_URL"
fi
echo ""

# Test 4: Verify Sources JAR download
print_info "Test 4: Sources JAR Download"
echo "============================"
SOURCES_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$SOURCES_URL")

if [ "$SOURCES_STATUS" -eq 200 ]; then
    print_status "Sources JAR downloadable (HTTP $SOURCES_STATUS)"
    echo "URL: $SOURCES_URL"
    
    # Get file size
    SOURCES_SIZE=$(curl -s -I "$SOURCES_URL" | grep -i content-length | awk '{print $2}' | tr -d '\r')
    if [ ! -z "$SOURCES_SIZE" ]; then
        SOURCES_SIZE_KB=$((SOURCES_SIZE / 1024))
        print_info "Sources size: ${SOURCES_SIZE_KB} KB"
    fi
else
    print_error "Sources JAR not downloadable (HTTP $SOURCES_STATUS)"
    echo "URL: $SOURCES_URL"
fi
echo ""

# Test 5: Verify Javadoc JAR download
print_info "Test 5: Javadoc JAR Download"
echo "============================"
JAVADOC_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$JAVADOC_URL")

if [ "$JAVADOC_STATUS" -eq 200 ]; then
    print_status "Javadoc JAR downloadable (HTTP $JAVADOC_STATUS)"
    echo "URL: $JAVADOC_URL"
    
    # Get file size
    JAVADOC_SIZE=$(curl -s -I "$JAVADOC_URL" | grep -i content-length | awk '{print $2}' | tr -d '\r')
    if [ ! -z "$JAVADOC_SIZE" ]; then
        JAVADOC_SIZE_KB=$((JAVADOC_SIZE / 1024))
        print_info "Javadoc size: ${JAVADOC_SIZE_KB} KB"
    fi
else
    print_error "Javadoc JAR not downloadable (HTTP $JAVADOC_STATUS)"
    echo "URL: $JAVADOC_URL"
fi
echo ""

# Summary
print_info "VERIFICATION SUMMARY"
echo "==================="

TOTAL_TESTS=5
PASSED_TESTS=0

# Count passed tests
[ "$RELEASE_STATUS" -eq 200 ] && ((PASSED_TESTS++))
[ "$LATEST_STATUS" -eq 200 ] && ((PASSED_TESTS++))
[ "$JAR_STATUS" -eq 200 ] && ((PASSED_TESTS++))
[ "$SOURCES_STATUS" -eq 200 ] && ((PASSED_TESTS++))
[ "$JAVADOC_STATUS" -eq 200 ] && ((PASSED_TESTS++))

echo "Tests Passed: $PASSED_TESTS/$TOTAL_TESTS"

if [ "$PASSED_TESTS" -eq "$TOTAL_TESTS" ]; then
    print_status "🎊 ALL TESTS PASSED - GITHUB RELEASE SUCCESSFUL!"
    echo ""
    echo "✅ Release page accessible"
    echo "✅ Latest release redirect working"
    echo "✅ Main JAR downloadable"
    echo "✅ Sources JAR downloadable"
    echo "✅ Javadoc JAR downloadable"
    echo ""
    print_info "🌐 Primary download URL:"
    echo "  $JAR_URL"
    echo ""
    print_status "🚀 AMCP Core v1.5.0 is now publicly available on GitHub!"
else
    print_warning "Some tests failed. Release may not be fully ready."
    echo ""
    print_info "If the release was just created, wait a few minutes for GitHub to process it."
    print_info "GitHub releases can take 1-2 minutes to become fully accessible."
fi

echo ""
print_info "Manual verification steps:"
echo "========================="
echo "1. Visit: https://github.com/agentmeshcommunicationprotocol/amcpcore.github.io/releases"
echo "2. Verify v1.5.0 release is visible and marked as 'Latest'"
echo "3. Click on each JAR file to test download"
echo "4. Verify release notes are properly formatted"
echo "5. Test the permanent download URL in a browser"
echo ""

print_status "GitHub release verification complete!"
