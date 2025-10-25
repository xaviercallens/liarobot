#!/bin/bash

echo "🔍 Verifying AMCP Core v1.5.0 on Maven Central"
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

# Maven Central URLs
GROUP_PATH="org/amcp"
ARTIFACT="amcp-core"
VERSION="1.5.0"
BASE_URL="https://repo1.maven.org/maven2/${GROUP_PATH}/${ARTIFACT}/${VERSION}"

JAR_URL="${BASE_URL}/${ARTIFACT}-${VERSION}.jar"
POM_URL="${BASE_URL}/${ARTIFACT}-${VERSION}.pom"
SOURCES_URL="${BASE_URL}/${ARTIFACT}-${VERSION}-sources.jar"
JAVADOC_URL="${BASE_URL}/${ARTIFACT}-${VERSION}-javadoc.jar"

# Maven Search API
SEARCH_URL="https://search.maven.org/solrsearch/select?q=g:org.amcp+AND+a:amcp-core&rows=20&wt=json"

print_info "Checking AMCP Core v1.5.0 availability on Maven Central..."
echo ""

# Test 1: Check main JAR
print_info "Test 1: Main JAR Availability"
echo "============================="
JAR_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$JAR_URL")

if [ "$JAR_STATUS" -eq 200 ]; then
    print_status "Main JAR available (HTTP $JAR_STATUS)"
    echo "URL: $JAR_URL"
    
    # Get file size
    JAR_SIZE=$(curl -s -I "$JAR_URL" | grep -i content-length | awk '{print $2}' | tr -d '\r')
    if [ ! -z "$JAR_SIZE" ]; then
        JAR_SIZE_KB=$((JAR_SIZE / 1024))
        print_info "JAR size: ${JAR_SIZE_KB} KB"
    fi
else
    print_error "Main JAR not available (HTTP $JAR_STATUS)"
    echo "URL: $JAR_URL"
fi
echo ""

# Test 2: Check POM
print_info "Test 2: POM Availability"
echo "========================"
POM_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$POM_URL")

if [ "$POM_STATUS" -eq 200 ]; then
    print_status "POM available (HTTP $POM_STATUS)"
    echo "URL: $POM_URL"
else
    print_error "POM not available (HTTP $POM_STATUS)"
    echo "URL: $POM_URL"
fi
echo ""

# Test 3: Check Sources JAR
print_info "Test 3: Sources JAR Availability"
echo "================================"
SOURCES_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$SOURCES_URL")

if [ "$SOURCES_STATUS" -eq 200 ]; then
    print_status "Sources JAR available (HTTP $SOURCES_STATUS)"
    echo "URL: $SOURCES_URL"
else
    print_error "Sources JAR not available (HTTP $SOURCES_STATUS)"
    echo "URL: $SOURCES_URL"
fi
echo ""

# Test 4: Check Javadoc JAR
print_info "Test 4: Javadoc JAR Availability"
echo "================================"
JAVADOC_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$JAVADOC_URL")

if [ "$JAVADOC_STATUS" -eq 200 ]; then
    print_status "Javadoc JAR available (HTTP $JAVADOC_STATUS)"
    echo "URL: $JAVADOC_URL"
else
    print_error "Javadoc JAR not available (HTTP $JAVADOC_STATUS)"
    echo "URL: $JAVADOC_URL"
fi
echo ""

# Test 5: Maven Search API
print_info "Test 5: Maven Search Integration"
echo "================================"
SEARCH_RESULT=$(curl -s "$SEARCH_URL")
SEARCH_STATUS=$?

if [ $SEARCH_STATUS -eq 0 ]; then
    # Check if our artifact is in the search results
    if echo "$SEARCH_RESULT" | grep -q "org.amcp"; then
        print_status "Artifact found in Maven search"
        
        # Extract version info
        VERSION_COUNT=$(echo "$SEARCH_RESULT" | grep -o '"latestVersion":"[^"]*"' | head -1)
        if [ ! -z "$VERSION_COUNT" ]; then
            print_info "Search result: $VERSION_COUNT"
        fi
    else
        print_warning "Artifact not yet indexed in Maven search"
        print_info "Note: Search indexing can take 2-4 hours after release"
    fi
else
    print_error "Maven search API not accessible"
fi
echo ""

# Test 6: Download and verify JAR
if [ "$JAR_STATUS" -eq 200 ]; then
    print_info "Test 6: JAR Download and Verification"
    echo "====================================="
    
    # Download JAR to temp location
    TEMP_JAR="/tmp/amcp-core-${VERSION}.jar"
    curl -s -o "$TEMP_JAR" "$JAR_URL"
    
    if [ -f "$TEMP_JAR" ]; then
        print_status "JAR downloaded successfully"
        
        # Check if it's a valid JAR
        if file "$TEMP_JAR" | grep -q "Java archive"; then
            print_status "Valid Java archive format"
            
            # List contents
            JAR_CONTENTS=$(jar tf "$TEMP_JAR" 2>/dev/null | head -5)
            if [ ! -z "$JAR_CONTENTS" ]; then
                print_info "JAR contents preview:"
                echo "$JAR_CONTENTS" | while read line; do
                    echo "  $line"
                done
            fi
        else
            print_error "Invalid Java archive format"
        fi
        
        # Clean up
        rm -f "$TEMP_JAR"
    else
        print_error "Failed to download JAR"
    fi
    echo ""
fi

# Summary
print_info "VERIFICATION SUMMARY"
echo "==================="

TOTAL_TESTS=4
PASSED_TESTS=0

# Count passed tests
[ "$JAR_STATUS" -eq 200 ] && ((PASSED_TESTS++))
[ "$POM_STATUS" -eq 200 ] && ((PASSED_TESTS++))
[ "$SOURCES_STATUS" -eq 200 ] && ((PASSED_TESTS++))
[ "$JAVADOC_STATUS" -eq 200 ] && ((PASSED_TESTS++))

echo "Core Tests Passed: $PASSED_TESTS/$TOTAL_TESTS"

if [ "$PASSED_TESTS" -eq "$TOTAL_TESTS" ]; then
    print_status "🎊 ALL TESTS PASSED - MAVEN CENTRAL DEPLOYMENT SUCCESSFUL!"
    echo ""
    echo "✅ Main JAR available on Maven Central"
    echo "✅ POM metadata available"
    echo "✅ Sources JAR available"
    echo "✅ Javadoc JAR available"
    echo ""
    print_info "🌐 Maven Central URLs:"
    echo "  Main JAR: $JAR_URL"
    echo "  POM: $POM_URL"
    echo "  Sources: $SOURCES_URL"
    echo "  Javadoc: $JAVADOC_URL"
    echo ""
    print_info "📦 Maven Dependency:"
    echo "  <dependency>"
    echo "    <groupId>org.amcp</groupId>"
    echo "    <artifactId>amcp-core</artifactId>"
    echo "    <version>1.5.0</version>"
    echo "  </dependency>"
    echo ""
    print_status "🚀 AMCP Core v1.5.0 is now globally available via Maven Central!"
elif [ "$PASSED_TESTS" -gt 0 ]; then
    print_warning "Partial deployment detected. Some artifacts may still be syncing."
    print_info "Maven Central sync can take 2-4 hours. Try again later."
else
    print_error "No artifacts found on Maven Central."
    print_info "Possible reasons:"
    echo "1. Deployment not yet completed"
    echo "2. Still in staging repository (not yet released)"
    echo "3. Sync to Maven Central still in progress"
    echo "4. Deployment failed - check Sonatype Nexus"
fi

echo ""
print_info "Additional verification options:"
echo "==============================="
echo "1. Maven Central Web Interface:"
echo "   https://repo1.maven.org/maven2/org/amcp/amcp-core/"
echo ""
echo "2. Maven Search:"
echo "   https://search.maven.org/search?q=g:org.amcp"
echo ""
echo "3. MVN Repository:"
echo "   https://mvnrepository.com/artifact/org.amcp/amcp-core"
echo ""
echo "4. Sonatype Nexus (for staging status):"
echo "   https://s01.oss.sonatype.org/"
echo ""

print_status "Maven Central verification complete!"
