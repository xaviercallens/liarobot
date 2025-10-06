#!/bin/bash

echo "🔍 Verifying AMCP Core v1.5.0 GitHub Release URL"
echo "==============================================="

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

# Target URLs to verify
BASE_URL="https://github.com/agentmeshcommunicationprotocol/amcpcore.github.io/releases"
LATEST_URL="${BASE_URL}/latest"
VERSION_URL="${BASE_URL}/tag/v1.5.0"

# Download URLs
JAR_URL="${BASE_URL}/latest/download/amcp-core-1.5.0.jar"
SOURCES_URL="${BASE_URL}/latest/download/amcp-core-1.5.0-sources.jar"
JAVADOC_URL="${BASE_URL}/latest/download/amcp-core-1.5.0-javadoc.jar"

print_info "🎯 TARGET URL VERIFICATION"
echo "=========================="
print_info "Primary Target: $JAR_URL"
echo ""

# Test 1: Check if release page exists
print_info "Test 1: Release Page Accessibility"
echo "=================================="
RELEASE_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$VERSION_URL")

if [ "$RELEASE_STATUS" -eq 200 ]; then
    print_status "Release page accessible (HTTP $RELEASE_STATUS)"
    echo "URL: $VERSION_URL"
elif [ "$RELEASE_STATUS" -eq 404 ]; then
    print_error "Release not found (HTTP $RELEASE_STATUS)"
    echo "URL: $VERSION_URL"
    print_info "❗ Release may not be created yet"
else
    print_warning "Unexpected response (HTTP $RELEASE_STATUS)"
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
    print_warning "Latest release redirect issue (HTTP $LATEST_STATUS)"
    echo "URL: $LATEST_URL"
fi
echo ""

# Test 3: Verify main JAR download (PRIMARY TARGET)
print_info "Test 3: 🎯 PRIMARY TARGET - Main JAR Download"
echo "============================================="
JAR_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$JAR_URL")

if [ "$JAR_STATUS" -eq 200 ]; then
    print_status "🎉 PRIMARY TARGET SUCCESSFUL!"
    print_status "Main JAR downloadable (HTTP $JAR_STATUS)"
    echo "✅ URL: $JAR_URL"
    
    # Get file size
    JAR_SIZE=$(curl -s -I "$JAR_URL" | grep -i content-length | awk '{print $2}' | tr -d '\r')
    if [ ! -z "$JAR_SIZE" ]; then
        JAR_SIZE_KB=$((JAR_SIZE / 1024))
        print_info "JAR size: ${JAR_SIZE_KB} KB"
    fi
    
    # Test actual download
    print_info "Testing actual download..."
    if curl -s -o /tmp/amcp-core-test.jar "$JAR_URL"; then
        if [ -f /tmp/amcp-core-test.jar ]; then
            TEST_SIZE=$(stat -c%s /tmp/amcp-core-test.jar 2>/dev/null || stat -f%z /tmp/amcp-core-test.jar 2>/dev/null)
            if [ "$TEST_SIZE" -gt 1000 ]; then
                print_status "Download test successful (${TEST_SIZE} bytes)"
                
                # Verify it's a valid JAR
                if file /tmp/amcp-core-test.jar | grep -q "Java archive\|Zip archive"; then
                    print_status "Valid Java archive confirmed"
                else
                    print_warning "File downloaded but may not be a valid JAR"
                fi
            else
                print_warning "Downloaded file seems too small (${TEST_SIZE} bytes)"
            fi
            rm -f /tmp/amcp-core-test.jar
        fi
    else
        print_warning "Download test failed"
    fi
    
elif [ "$JAR_STATUS" -eq 404 ]; then
    print_error "❌ PRIMARY TARGET FAILED"
    print_error "Main JAR not found (HTTP $JAR_STATUS)"
    echo "❌ URL: $JAR_URL"
    print_info "❗ This means the GitHub release is not yet created or not marked as 'Latest'"
else
    print_error "❌ PRIMARY TARGET ISSUE"
    print_error "Main JAR not accessible (HTTP $JAR_STATUS)"
    echo "❌ URL: $JAR_URL"
fi
echo ""

# Test 4: Verify Sources JAR download
print_info "Test 4: Sources JAR Download"
echo "============================"
SOURCES_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$SOURCES_URL")

if [ "$SOURCES_STATUS" -eq 200 ]; then
    print_status "Sources JAR downloadable (HTTP $SOURCES_STATUS)"
    echo "URL: $SOURCES_URL"
    
    SOURCES_SIZE=$(curl -s -I "$SOURCES_URL" | grep -i content-length | awk '{print $2}' | tr -d '\r')
    if [ ! -z "$SOURCES_SIZE" ]; then
        SOURCES_SIZE_KB=$((SOURCES_SIZE / 1024))
        print_info "Sources size: ${SOURCES_SIZE_KB} KB"
    fi
else
    print_warning "Sources JAR not accessible (HTTP $SOURCES_STATUS)"
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
    
    JAVADOC_SIZE=$(curl -s -I "$JAVADOC_URL" | grep -i content-length | awk '{print $2}' | tr -d '\r')
    if [ ! -z "$JAVADOC_SIZE" ]; then
        JAVADOC_SIZE_KB=$((JAVADOC_SIZE / 1024))
        print_info "Javadoc size: ${JAVADOC_SIZE_KB} KB"
    fi
else
    print_warning "Javadoc JAR not accessible (HTTP $JAVADOC_STATUS)"
    echo "URL: $JAVADOC_URL"
fi
echo ""

# Summary
print_info "🎯 VERIFICATION SUMMARY"
echo "======================"

TOTAL_TESTS=5
PASSED_TESTS=0

# Count passed tests
[ "$RELEASE_STATUS" -eq 200 ] && ((PASSED_TESTS++))
[ "$LATEST_STATUS" -eq 200 ] && ((PASSED_TESTS++))
[ "$JAR_STATUS" -eq 200 ] && ((PASSED_TESTS++))
[ "$SOURCES_STATUS" -eq 200 ] && ((PASSED_TESTS++))
[ "$JAVADOC_STATUS" -eq 200 ] && ((PASSED_TESTS++))

echo "Tests Passed: $PASSED_TESTS/$TOTAL_TESTS"
echo ""

if [ "$JAR_STATUS" -eq 200 ]; then
    print_status "🎊 PRIMARY OBJECTIVE ACHIEVED!"
    echo ""
    print_status "✅ AMCP Core v1.5.0 JAR is globally accessible!"
    echo ""
    print_info "🌐 Primary Download URL (WORKING):"
    echo "  $JAR_URL"
    echo ""
    print_info "📦 Usage Examples:"
    echo "  # Direct download"
    echo "  wget $JAR_URL"
    echo ""
    echo "  # Add to Java classpath"
    echo "  java -cp amcp-core-1.5.0.jar:. MyApplication"
    echo ""
    print_info "🔗 All Download URLs:"
    echo "  Main JAR: $JAR_URL"
    echo "  Sources:  $SOURCES_URL"
    echo "  Javadoc:  $JAVADOC_URL"
    echo ""
    print_status "🚀 PRIORITY 1 SUCCESSFULLY COMPLETED!"
    
elif [ "$PASSED_TESTS" -gt 0 ]; then
    print_warning "⚠️ Partial success - some components working"
    print_info "GitHub release may still be processing"
    print_info "Wait 1-2 minutes and run this script again"
    
else
    print_error "❌ GitHub release not yet available"
    print_info "Possible reasons:"
    echo "1. 📝 Release not yet created"
    echo "2. 🏷️ Release not tagged as 'Latest'"
    echo "3. ⏳ GitHub still processing the release"
    echo "4. 📁 JAR files not uploaded correctly"
    echo ""
    print_info "✅ Next steps:"
    echo "1. Create the GitHub release manually using: GITHUB_RELEASE_MANUAL_PROCESS.md"
    echo "2. Ensure release is marked as 'Latest'"
    echo "3. Upload all 3 JAR files"
    echo "4. Run this verification script again"
fi

echo ""
print_info "📋 Manual verification:"
echo "======================"
echo "1. Visit: https://github.com/agentmeshcommunicationprotocol/amcpcore.github.io/releases"
echo "2. Verify v1.5.0 release is visible and marked as 'Latest'"
echo "3. Click on each JAR file to test download"
echo "4. Test the permanent URL in a browser: $JAR_URL"
echo ""

print_status "GitHub release verification complete!"

# Exit with appropriate code
if [ "$JAR_STATUS" -eq 200 ]; then
    exit 0  # Success
else
    exit 1  # Primary objective not yet achieved
fi
