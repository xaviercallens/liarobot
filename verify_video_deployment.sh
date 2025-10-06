#!/bin/bash

echo "🎬 AMCP Video Deployment Verification"
echo "====================================="
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

# Website URLs
MAIN_SITE="https://agentmeshcommunicationprotocol.github.io/"
VIDEO_URL="https://agentmeshcommunicationprotocol.github.io/promo/AMCP__The_Agent_Superhighway.mp4"

print_info "Verifying AMCP video deployment..."
echo ""

# Test 1: Main site accessibility
print_info "Test 1: Main Site Accessibility"
echo "==============================="
MAIN_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$MAIN_SITE")

if [ "$MAIN_STATUS" -eq 200 ]; then
    print_status "Main site accessible (HTTP $MAIN_STATUS)"
    echo "URL: $MAIN_SITE"
else
    print_error "Main site not accessible (HTTP $MAIN_STATUS)"
fi
echo ""

# Test 2: Video file accessibility
print_info "Test 2: Video File Accessibility"
echo "================================"
VIDEO_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$VIDEO_URL")

if [ "$VIDEO_STATUS" -eq 200 ]; then
    print_status "Video file accessible (HTTP $VIDEO_STATUS)"
    
    # Get video file size
    VIDEO_SIZE=$(curl -s -I "$VIDEO_URL" | grep -i content-length | awk '{print $2}' | tr -d '\r')
    if [ ! -z "$VIDEO_SIZE" ]; then
        VIDEO_SIZE_MB=$((VIDEO_SIZE / 1024 / 1024))
        print_info "Video file size: ${VIDEO_SIZE_MB} MB"
    fi
    
    echo "URL: $VIDEO_URL"
else
    print_error "Video file not accessible (HTTP $VIDEO_STATUS)"
fi
echo ""

# Test 3: Video section presence on homepage
print_info "Test 3: Video Section Integration"
echo "================================="
VIDEO_SECTION_CHECK=$(curl -s "$MAIN_SITE" | grep -c "video-section")

if [ "$VIDEO_SECTION_CHECK" -gt 0 ]; then
    print_status "Video section found on homepage"
    print_info "Video section instances: $VIDEO_SECTION_CHECK"
else
    print_error "Video section not found on homepage"
fi

# Test 4: Video element presence
VIDEO_ELEMENT_CHECK=$(curl -s "$MAIN_SITE" | grep -c "AMCP__The_Agent_Superhighway.mp4")

if [ "$VIDEO_ELEMENT_CHECK" -gt 0 ]; then
    print_status "Video element found in HTML"
    print_info "Video references: $VIDEO_ELEMENT_CHECK"
else
    print_error "Video element not found in HTML"
fi
echo ""

# Test 5: Video title presence
print_info "Test 4: Video Content Verification"
echo "=================================="
VIDEO_TITLE_CHECK=$(curl -s "$MAIN_SITE" | grep -c "AMCP: The Agent Superhighway")

if [ "$VIDEO_TITLE_CHECK" -gt 0 ]; then
    print_status "Video title found on page"
    print_info "Title references: $VIDEO_TITLE_CHECK"
else
    print_error "Video title not found on page"
fi

# Test 6: Video highlights presence
VIDEO_HIGHLIGHTS_CHECK=$(curl -s "$MAIN_SITE" | grep -c "video-highlights")

if [ "$VIDEO_HIGHLIGHTS_CHECK" -gt 0 ]; then
    print_status "Video highlights section found"
    print_info "Highlights instances: $VIDEO_HIGHLIGHTS_CHECK"
else
    print_error "Video highlights section not found"
fi
echo ""

# Test 7: CSS styling presence
print_info "Test 5: CSS Styling Verification"
echo "================================"
VIDEO_CSS_CHECK=$(curl -s "$MAIN_SITE" | grep -c "\.video-section")

if [ "$VIDEO_CSS_CHECK" -gt 0 ]; then
    print_status "Video CSS styling found"
    print_info "CSS rule instances: $VIDEO_CSS_CHECK"
else
    print_error "Video CSS styling not found"
fi
echo ""

# Summary
print_info "VERIFICATION SUMMARY"
echo "==================="

TOTAL_TESTS=7
PASSED_TESTS=0

# Count passed tests
[ "$MAIN_STATUS" -eq 200 ] && ((PASSED_TESTS++))
[ "$VIDEO_STATUS" -eq 200 ] && ((PASSED_TESTS++))
[ "$VIDEO_SECTION_CHECK" -gt 0 ] && ((PASSED_TESTS++))
[ "$VIDEO_ELEMENT_CHECK" -gt 0 ] && ((PASSED_TESTS++))
[ "$VIDEO_TITLE_CHECK" -gt 0 ] && ((PASSED_TESTS++))
[ "$VIDEO_HIGHLIGHTS_CHECK" -gt 0 ] && ((PASSED_TESTS++))
[ "$VIDEO_CSS_CHECK" -gt 0 ] && ((PASSED_TESTS++))

echo "Tests Passed: $PASSED_TESTS/$TOTAL_TESTS"

if [ "$PASSED_TESTS" -eq "$TOTAL_TESTS" ]; then
    print_status "🎊 ALL TESTS PASSED - VIDEO DEPLOYMENT SUCCESSFUL!"
    echo ""
    echo "✅ Main site accessible at root domain"
    echo "✅ Video file properly hosted and accessible"
    echo "✅ Video section integrated into homepage"
    echo "✅ Video element present in HTML"
    echo "✅ Video content and styling complete"
    echo ""
    print_info "🌐 Visit: $MAIN_SITE"
    print_info "🎬 Video: Prominently featured on homepage"
    echo ""
    print_status "🚀 AMCP promotional video is live and ready to engage visitors!"
else
    print_warning "Some tests failed. Please check the issues above."
fi

echo ""
print_info "Manual Verification Steps:"
echo "========================="
echo "1. Visit: $MAIN_SITE"
echo "2. Scroll to 'AMCP: The Agent Superhighway' section"
echo "3. Click play button on the video"
echo "4. Verify video plays correctly"
echo "5. Test responsive design on mobile devices"
echo ""

print_status "Video deployment verification complete!"
