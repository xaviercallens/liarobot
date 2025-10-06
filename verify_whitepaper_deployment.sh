#!/bin/bash

echo "📄 AMCP Whitepaper Deployment Verification"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

# URLs
MAIN_SITE="https://agentmeshcommunicationprotocol.github.io/"
WHITEPAPER_URL="https://agentmeshcommunicationprotocol.github.io/whitepaper/"

print_info "Verifying AMCP whitepaper deployment..."
echo ""

# Test 1: Whitepaper page accessibility
print_info "Test 1: Whitepaper Page Accessibility"
echo "====================================="
WHITEPAPER_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$WHITEPAPER_URL")

if [ "$WHITEPAPER_STATUS" -eq 200 ]; then
    print_status "Whitepaper page accessible (HTTP $WHITEPAPER_STATUS)"
    echo "URL: $WHITEPAPER_URL"
    
    # Get page size
    PAGE_SIZE=$(curl -s -I "$WHITEPAPER_URL" | grep -i content-length | awk '{print $2}' | tr -d '\r')
    if [ ! -z "$PAGE_SIZE" ]; then
        PAGE_SIZE_KB=$((PAGE_SIZE / 1024))
        print_info "Page size: ${PAGE_SIZE_KB} KB"
    fi
else
    print_error "Whitepaper page not accessible (HTTP $WHITEPAPER_STATUS)"
fi
echo ""

# Test 2: Navigation menu integration
print_info "Test 2: Navigation Menu Integration"
echo "=================================="
NAV_CHECK=$(curl -s "$MAIN_SITE" | grep -c "href=\"/whitepaper/\"")

if [ "$NAV_CHECK" -gt 0 ]; then
    print_status "Whitepaper link found in navigation menu"
    print_info "Navigation references: $NAV_CHECK"
else
    print_error "Whitepaper link not found in navigation menu"
fi
echo ""

# Test 3: Page title and content verification
print_info "Test 3: Page Content Verification"
echo "================================="
TITLE_CHECK=$(curl -s "$WHITEPAPER_URL" | grep -c "Architecting Resilient Distributed AI Systems")

if [ "$TITLE_CHECK" -gt 0 ]; then
    print_status "Whitepaper title found on page"
    print_info "Title references: $TITLE_CHECK"
else
    print_error "Whitepaper title not found on page"
fi

# Test 4: Table of contents verification
TOC_CHECK=$(curl -s "$WHITEPAPER_URL" | grep -c "whitepaper-toc")

if [ "$TOC_CHECK" -gt 0 ]; then
    print_status "Table of contents found"
    print_info "TOC instances: $TOC_CHECK"
else
    print_error "Table of contents not found"
fi
echo ""

# Test 5: Architectural pillars content
print_info "Test 4: Technical Content Verification"
echo "======================================"
PILLARS_CHECK=$(curl -s "$WHITEPAPER_URL" | grep -c "pillar-card")

if [ "$PILLARS_CHECK" -gt 0 ]; then
    print_status "Architectural pillars content found"
    print_info "Pillar sections: $PILLARS_CHECK"
else
    print_error "Architectural pillars content not found"
fi

# Test 6: Use cases section
USE_CASES_CHECK=$(curl -s "$WHITEPAPER_URL" | grep -c "use-case-card")

if [ "$USE_CASES_CHECK" -gt 0 ]; then
    print_status "Use cases section found"
    print_info "Use case examples: $USE_CASES_CHECK"
else
    print_error "Use cases section not found"
fi
echo ""

# Test 7: CSS styling verification
print_info "Test 5: Styling and Layout Verification"
echo "======================================="
CSS_CHECK=$(curl -s "$WHITEPAPER_URL" | grep -c "whitepaper-container")

if [ "$CSS_CHECK" -gt 0 ]; then
    print_status "Whitepaper styling found"
    print_info "Style containers: $CSS_CHECK"
else
    print_error "Whitepaper styling not found"
fi

# Test 8: Call-to-action buttons
CTA_CHECK=$(curl -s "$WHITEPAPER_URL" | grep -c "call-to-action")

if [ "$CTA_CHECK" -gt 0 ]; then
    print_status "Call-to-action section found"
    print_info "CTA sections: $CTA_CHECK"
else
    print_error "Call-to-action section not found"
fi
echo ""

# Summary
print_info "VERIFICATION SUMMARY"
echo "==================="

TOTAL_TESTS=8
PASSED_TESTS=0

# Count passed tests
[ "$WHITEPAPER_STATUS" -eq 200 ] && ((PASSED_TESTS++))
[ "$NAV_CHECK" -gt 0 ] && ((PASSED_TESTS++))
[ "$TITLE_CHECK" -gt 0 ] && ((PASSED_TESTS++))
[ "$TOC_CHECK" -gt 0 ] && ((PASSED_TESTS++))
[ "$PILLARS_CHECK" -gt 0 ] && ((PASSED_TESTS++))
[ "$USE_CASES_CHECK" -gt 0 ] && ((PASSED_TESTS++))
[ "$CSS_CHECK" -gt 0 ] && ((PASSED_TESTS++))
[ "$CTA_CHECK" -gt 0 ] && ((PASSED_TESTS++))

echo "Tests Passed: $PASSED_TESTS/$TOTAL_TESTS"

if [ "$PASSED_TESTS" -eq "$TOTAL_TESTS" ]; then
    print_status "🎊 ALL TESTS PASSED - WHITEPAPER DEPLOYMENT SUCCESSFUL!"
    echo ""
    echo "✅ Whitepaper accessible at correct URL"
    echo "✅ Navigation menu integration complete"
    echo "✅ Page content and structure verified"
    echo "✅ Technical sections properly displayed"
    echo "✅ Professional styling and layout active"
    echo ""
    print_info "🌐 Visit: $WHITEPAPER_URL"
    print_info "📄 Content: Complete technical whitepaper"
    echo ""
    print_status "🚀 AMCP whitepaper is live and ready to establish technical authority!"
else
    print_warning "Some tests failed. Please check the issues above."
fi

echo ""
print_info "Manual Verification Checklist:"
echo "=============================="
echo "1. Visit: $WHITEPAPER_URL"
echo "2. Verify professional layout and styling"
echo "3. Test table of contents navigation"
echo "4. Scroll through all sections"
echo "5. Test call-to-action buttons"
echo "6. Verify responsive design on mobile"
echo ""

print_status "Whitepaper deployment verification complete!"
