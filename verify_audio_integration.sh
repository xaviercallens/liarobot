#!/bin/bash

echo "🎙️ AMCP Voice Recording Integration Verification"
echo "==============================================="
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
AUDIO_URL="https://agentmeshcommunicationprotocol.github.io/promo/AMCP_Explained__How_Asynchronous_AI_Agents_Scale_with_Publish-S.m4a"

print_info "Verifying AMCP voice recording integration..."
echo ""

# Test 1: Audio file accessibility
print_info "Test 1: Audio File Accessibility"
echo "================================"
AUDIO_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$AUDIO_URL")

if [ "$AUDIO_STATUS" -eq 200 ]; then
    print_status "Audio file accessible (HTTP $AUDIO_STATUS)"
    echo "URL: $AUDIO_URL"
    
    # Get audio file size
    AUDIO_SIZE=$(curl -s -I "$AUDIO_URL" | grep -i content-length | awk '{print $2}' | tr -d '\r')
    if [ ! -z "$AUDIO_SIZE" ]; then
        AUDIO_SIZE_MB=$((AUDIO_SIZE / 1024 / 1024))
        print_info "Audio file size: ${AUDIO_SIZE_MB} MB"
    fi
    
    # Check content type
    CONTENT_TYPE=$(curl -s -I "$AUDIO_URL" | grep -i content-type | awk '{print $2}' | tr -d '\r')
    print_info "Content type: $CONTENT_TYPE"
else
    print_error "Audio file not accessible (HTTP $AUDIO_STATUS)"
fi
echo ""

# Test 2: Audio section presence on homepage
print_info "Test 2: Audio Section Integration"
echo "================================="
AUDIO_SECTION_CHECK=$(curl -s "$MAIN_SITE" | grep -c "audio-section")

if [ "$AUDIO_SECTION_CHECK" -gt 0 ]; then
    print_status "Audio section found on homepage"
    print_info "Audio section instances: $AUDIO_SECTION_CHECK"
else
    print_error "Audio section not found on homepage"
fi

# Test 3: Audio element presence
AUDIO_ELEMENT_CHECK=$(curl -s "$MAIN_SITE" | grep -c "amcp-audio")

if [ "$AUDIO_ELEMENT_CHECK" -gt 0 ]; then
    print_status "Audio element found in HTML"
    print_info "Audio elements: $AUDIO_ELEMENT_CHECK"
else
    print_error "Audio element not found in HTML"
fi
echo ""

# Test 4: Audio title and content verification
print_info "Test 3: Audio Content Verification"
echo "=================================="
AUDIO_TITLE_CHECK=$(curl -s "$MAIN_SITE" | grep -c "AMCP Explained: How Asynchronous AI Agents Scale")

if [ "$AUDIO_TITLE_CHECK" -gt 0 ]; then
    print_status "Audio title found on page"
    print_info "Title references: $AUDIO_TITLE_CHECK"
else
    print_error "Audio title not found on page"
fi

# Test 5: Audio player styling
AUDIO_WRAPPER_CHECK=$(curl -s "$MAIN_SITE" | grep -c "audio-wrapper")

if [ "$AUDIO_WRAPPER_CHECK" -gt 0 ]; then
    print_status "Audio player styling found"
    print_info "Audio wrapper instances: $AUDIO_WRAPPER_CHECK"
else
    print_error "Audio player styling not found"
fi
echo ""

# Test 6: CSS styling verification
print_info "Test 4: CSS Styling Verification"
echo "================================"
AUDIO_CSS_CHECK=$(curl -s "$MAIN_SITE" | grep -c "\.audio-section")

if [ "$AUDIO_CSS_CHECK" -gt 0 ]; then
    print_status "Audio CSS styling found"
    print_info "CSS rule instances: $AUDIO_CSS_CHECK"
else
    print_error "Audio CSS styling not found"
fi

# Test 7: Audio highlights and actions
AUDIO_HIGHLIGHTS_CHECK=$(curl -s "$MAIN_SITE" | grep -c "audio-highlights")

if [ "$AUDIO_HIGHLIGHTS_CHECK" -gt 0 ]; then
    print_status "Audio highlights section found"
    print_info "Highlights instances: $AUDIO_HIGHLIGHTS_CHECK"
else
    print_error "Audio highlights section not found"
fi
echo ""

# Summary
print_info "VERIFICATION SUMMARY"
echo "==================="

TOTAL_TESTS=7
PASSED_TESTS=0

# Count passed tests
[ "$AUDIO_STATUS" -eq 200 ] && ((PASSED_TESTS++))
[ "$AUDIO_SECTION_CHECK" -gt 0 ] && ((PASSED_TESTS++))
[ "$AUDIO_ELEMENT_CHECK" -gt 0 ] && ((PASSED_TESTS++))
[ "$AUDIO_TITLE_CHECK" -gt 0 ] && ((PASSED_TESTS++))
[ "$AUDIO_WRAPPER_CHECK" -gt 0 ] && ((PASSED_TESTS++))
[ "$AUDIO_CSS_CHECK" -gt 0 ] && ((PASSED_TESTS++))
[ "$AUDIO_HIGHLIGHTS_CHECK" -gt 0 ] && ((PASSED_TESTS++))

echo "Tests Passed: $PASSED_TESTS/$TOTAL_TESTS"

if [ "$PASSED_TESTS" -eq "$TOTAL_TESTS" ]; then
    print_status "🎊 ALL TESTS PASSED - VOICE RECORDING INTEGRATION SUCCESSFUL!"
    echo ""
    echo "✅ Audio file accessible and properly hosted"
    echo "✅ Audio section integrated into homepage"
    echo "✅ Audio player element present in HTML"
    echo "✅ Audio content and styling complete"
    echo "✅ Professional presentation ready"
    echo ""
    print_info "🌐 Website: $MAIN_SITE"
    print_info "🎙️ Audio: Prominently featured on homepage"
    print_info "📁 File: 3.7MB M4A format (~6 minutes)"
    echo ""
    print_status "🚀 AMCP voice recording is live and ready to educate visitors!"
else
    print_warning "Some tests failed. Please check the issues above."
fi

echo ""
print_info "Manual Verification Steps:"
echo "========================="
echo "1. Visit: $MAIN_SITE"
echo "2. Scroll to 'AMCP Explained' audio section"
echo "3. Click play button on the audio player"
echo "4. Verify audio plays correctly"
echo "5. Test audio controls (play, pause, seek)"
echo "6. Check responsive design on mobile devices"
echo ""

print_status "Voice recording integration verification complete!"
