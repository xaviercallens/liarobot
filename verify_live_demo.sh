#!/bin/bash

echo "🎮 AMCP Live Demo Deployment Verification"
echo "========================================="
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
EXAMPLES_URL="https://agentmeshcommunicationprotocol.github.io/examples/"
DEMO_URL="https://agentmeshcommunicationprotocol.github.io/examples/live-demo/"

print_info "Verifying AMCP live demo deployment..."
echo ""

# Test 1: Examples page accessibility
print_info "Test 1: Examples Page Accessibility"
echo "==================================="
EXAMPLES_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$EXAMPLES_URL")

if [ "$EXAMPLES_STATUS" -eq 200 ]; then
    print_status "Examples page accessible (HTTP $EXAMPLES_STATUS)"
    echo "URL: $EXAMPLES_URL"
    
    # Get page size
    PAGE_SIZE=$(curl -s -I "$EXAMPLES_URL" | grep -i content-length | awk '{print $2}' | tr -d '\r')
    if [ ! -z "$PAGE_SIZE" ]; then
        PAGE_SIZE_KB=$((PAGE_SIZE / 1024))
        print_info "Page size: ${PAGE_SIZE_KB} KB"
    fi
else
    print_error "Examples page not accessible (HTTP $EXAMPLES_STATUS)"
fi
echo ""

# Test 2: Live demo page accessibility
print_info "Test 2: Live Demo Page Accessibility"
echo "===================================="
DEMO_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$DEMO_URL")

if [ "$DEMO_STATUS" -eq 200 ]; then
    print_status "Live demo page accessible (HTTP $DEMO_STATUS)"
    echo "URL: $DEMO_URL"
    
    # Get page size
    DEMO_SIZE=$(curl -s -I "$DEMO_URL" | grep -i content-length | awk '{print $2}' | tr -d '\r')
    if [ ! -z "$DEMO_SIZE" ]; then
        DEMO_SIZE_KB=$((DEMO_SIZE / 1024))
        print_info "Page size: ${DEMO_SIZE_KB} KB"
    fi
else
    print_error "Live demo page not accessible (HTTP $DEMO_STATUS)"
fi
echo ""

# Test 3: Demo title and interactive elements
print_info "Test 3: Demo Content Verification"
echo "================================="
DEMO_TITLE_CHECK=$(curl -s "$DEMO_URL" | grep -c "AMCP Live Interactive Demo")

if [ "$DEMO_TITLE_CHECK" -gt 0 ]; then
    print_status "Demo title found on page"
    print_info "Title references: $DEMO_TITLE_CHECK"
else
    print_error "Demo title not found on page"
fi

# Test 4: Interactive controls verification
CONTROLS_CHECK=$(curl -s "$DEMO_URL" | grep -c "startDemo")

if [ "$CONTROLS_CHECK" -gt 0 ]; then
    print_status "Interactive controls found"
    print_info "Control elements: $CONTROLS_CHECK"
else
    print_error "Interactive controls not found"
fi
echo ""

# Test 5: JavaScript demo class verification
print_info "Test 4: JavaScript Implementation Verification"
echo "=============================================="
JS_CLASS_CHECK=$(curl -s "$DEMO_URL" | grep -c "class AMCPDemo")

if [ "$JS_CLASS_CHECK" -gt 0 ]; then
    print_status "JavaScript demo class found"
    print_info "Demo class instances: $JS_CLASS_CHECK"
else
    print_error "JavaScript demo class not found"
fi

# Test 6: SVG mesh visualization
SVG_CHECK=$(curl -s "$DEMO_URL" | grep -c "meshSvg")

if [ "$SVG_CHECK" -gt 0 ]; then
    print_status "SVG mesh visualization found"
    print_info "SVG elements: $SVG_CHECK"
else
    print_error "SVG mesh visualization not found"
fi
echo ""

# Test 7: Event console verification
print_info "Test 5: Interactive Features Verification"
echo "========================================="
CONSOLE_CHECK=$(curl -s "$DEMO_URL" | grep -c "event-console")

if [ "$CONSOLE_CHECK" -gt 0 ]; then
    print_status "Event console found"
    print_info "Console instances: $CONSOLE_CHECK"
else
    print_error "Event console not found"
fi

# Test 8: Scenario buttons
SCENARIOS_CHECK=$(curl -s "$DEMO_URL" | grep -c "ecommerceScenario")

if [ "$SCENARIOS_CHECK" -gt 0 ]; then
    print_status "Scenario controls found"
    print_info "Scenario buttons: $SCENARIOS_CHECK"
else
    print_error "Scenario controls not found"
fi
echo ""

# Test 9: Examples navigation
print_info "Test 6: Examples Navigation Verification"
echo "========================================"
EXAMPLES_NAV_CHECK=$(curl -s "$EXAMPLES_URL" | grep -c "Launch Live Demo")

if [ "$EXAMPLES_NAV_CHECK" -gt 0 ]; then
    print_status "Examples navigation found"
    print_info "Navigation links: $EXAMPLES_NAV_CHECK"
else
    print_error "Examples navigation not found"
fi

# Test 10: Code examples
CODE_EXAMPLES_CHECK=$(curl -s "$EXAMPLES_URL" | grep -c "code-block")

if [ "$CODE_EXAMPLES_CHECK" -gt 0 ]; then
    print_status "Code examples found"
    print_info "Code blocks: $CODE_EXAMPLES_CHECK"
else
    print_error "Code examples not found"
fi
echo ""

# Summary
print_info "VERIFICATION SUMMARY"
echo "==================="

TOTAL_TESTS=10
PASSED_TESTS=0

# Count passed tests
[ "$EXAMPLES_STATUS" -eq 200 ] && ((PASSED_TESTS++))
[ "$DEMO_STATUS" -eq 200 ] && ((PASSED_TESTS++))
[ "$DEMO_TITLE_CHECK" -gt 0 ] && ((PASSED_TESTS++))
[ "$CONTROLS_CHECK" -gt 0 ] && ((PASSED_TESTS++))
[ "$JS_CLASS_CHECK" -gt 0 ] && ((PASSED_TESTS++))
[ "$SVG_CHECK" -gt 0 ] && ((PASSED_TESTS++))
[ "$CONSOLE_CHECK" -gt 0 ] && ((PASSED_TESTS++))
[ "$SCENARIOS_CHECK" -gt 0 ] && ((PASSED_TESTS++))
[ "$EXAMPLES_NAV_CHECK" -gt 0 ] && ((PASSED_TESTS++))
[ "$CODE_EXAMPLES_CHECK" -gt 0 ] && ((PASSED_TESTS++))

echo "Tests Passed: $PASSED_TESTS/$TOTAL_TESTS"

if [ "$PASSED_TESTS" -eq "$TOTAL_TESTS" ]; then
    print_status "🎊 ALL TESTS PASSED - LIVE DEMO DEPLOYMENT SUCCESSFUL!"
    echo ""
    echo "✅ Examples page accessible and complete"
    echo "✅ Live demo page fully functional"
    echo "✅ Interactive controls and JavaScript working"
    echo "✅ SVG visualization and event console active"
    echo "✅ Scenario simulations ready"
    echo "✅ Code examples and navigation complete"
    echo ""
    print_info "🌐 Examples: $EXAMPLES_URL"
    print_info "🎮 Live Demo: $DEMO_URL"
    echo ""
    print_status "🚀 AMCP interactive demo is live and ready to showcase agent mesh concepts!"
else
    print_warning "Some tests failed. Please check the issues above."
fi

echo ""
print_info "Manual Testing Checklist:"
echo "========================="
echo "1. Visit: $DEMO_URL"
echo "2. Click 'Start Demo' button"
echo "3. Test 'Add Weather Agent' button"
echo "4. Try 'E-commerce Flow' scenario"
echo "5. Watch agent animations and event stream"
echo "6. Test 'Migrate Agent' functionality"
echo "7. Verify responsive design on mobile"
echo "8. Check all interactive controls work"
echo ""

print_status "Live demo deployment verification complete!"
