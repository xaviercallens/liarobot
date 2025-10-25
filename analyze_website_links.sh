#!/bin/bash

echo "🔗 AMCP Website Link Analysis & Coverage Report"
echo "=============================================="
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

# Base URL
BASE_URL="https://agentmeshcommunicationprotocol.github.io"

# Arrays to store results
declare -a WORKING_LINKS=()
declare -a BROKEN_LINKS=()
declare -a EXTERNAL_LINKS=()

print_info "Analyzing AMCP website links..."
echo ""

# Function to check link status
check_link() {
    local url="$1"
    local status=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    echo "$status"
}

# Function to extract links from a page
extract_links() {
    local page_url="$1"
    local page_content=$(curl -s "$page_url")
    
    # Extract href attributes
    echo "$page_content" | grep -oP 'href="[^"]*"' | sed 's/href="//g' | sed 's/"//g' | sort | uniq
}

print_info "Phase 1: Analyzing Homepage Links"
echo "================================="

# Get all links from homepage
HOMEPAGE_LINKS=$(extract_links "$BASE_URL")

TOTAL_LINKS=0
WORKING_COUNT=0
BROKEN_COUNT=0
EXTERNAL_COUNT=0

# Process each link
while IFS= read -r link; do
    if [ -z "$link" ]; then
        continue
    fi
    
    ((TOTAL_LINKS++))
    
    # Skip anchors and javascript
    if [[ "$link" == "#"* ]] || [[ "$link" == "javascript:"* ]]; then
        continue
    fi
    
    # Determine full URL
    if [[ "$link" == "http"* ]]; then
        # External link
        FULL_URL="$link"
        ((EXTERNAL_COUNT++))
        EXTERNAL_LINKS+=("$FULL_URL")
        print_info "External: $FULL_URL"
    elif [[ "$link" == "/"* ]]; then
        # Internal absolute link
        FULL_URL="${BASE_URL}${link}"
    else
        # Internal relative link
        FULL_URL="${BASE_URL}/${link}"
    fi
    
    # Check internal links only
    if [[ "$FULL_URL" == "$BASE_URL"* ]]; then
        STATUS=$(check_link "$FULL_URL")
        
        if [ "$STATUS" -eq 200 ]; then
            ((WORKING_COUNT++))
            WORKING_LINKS+=("$FULL_URL")
            print_status "Working: $FULL_URL"
        else
            ((BROKEN_COUNT++))
            BROKEN_LINKS+=("$FULL_URL")
            print_error "Broken ($STATUS): $FULL_URL"
        fi
    fi
    
done <<< "$HOMEPAGE_LINKS"

echo ""
print_info "Phase 2: Analyzing Key Pages"
echo "============================"

# Key pages to check
KEY_PAGES=(
    "$BASE_URL/whitepaper/"
    "$BASE_URL/examples/"
    "$BASE_URL/examples/live-demo/"
)

for page in "${KEY_PAGES[@]}"; do
    STATUS=$(check_link "$page")
    if [ "$STATUS" -eq 200 ]; then
        print_status "Key page working: $page"
        
        # Extract links from this page too
        PAGE_LINKS=$(extract_links "$page")
        while IFS= read -r link; do
            if [ -z "$link" ] || [[ "$link" == "#"* ]] || [[ "$link" == "javascript:"* ]]; then
                continue
            fi
            
            ((TOTAL_LINKS++))
            
            if [[ "$link" == "http"* ]]; then
                ((EXTERNAL_COUNT++))
                if [[ ! " ${EXTERNAL_LINKS[@]} " =~ " ${link} " ]]; then
                    EXTERNAL_LINKS+=("$link")
                fi
            elif [[ "$link" == "/"* ]]; then
                FULL_URL="${BASE_URL}${link}"
                STATUS=$(check_link "$FULL_URL")
                
                if [ "$STATUS" -eq 200 ]; then
                    if [[ ! " ${WORKING_LINKS[@]} " =~ " ${FULL_URL} " ]]; then
                        ((WORKING_COUNT++))
                        WORKING_LINKS+=("$FULL_URL")
                    fi
                else
                    if [[ ! " ${BROKEN_LINKS[@]} " =~ " ${FULL_URL} " ]]; then
                        ((BROKEN_COUNT++))
                        BROKEN_LINKS+=("$FULL_URL")
                    fi
                fi
            fi
        done <<< "$PAGE_LINKS"
    else
        print_error "Key page broken ($STATUS): $page"
        ((BROKEN_COUNT++))
        BROKEN_LINKS+=("$page")
    fi
done

echo ""
print_info "Phase 3: Navigation Menu Analysis"
echo "================================="

# Check navigation links from config
NAV_LINKS=(
    "$BASE_URL/"
    "$BASE_URL/whitepaper/"
    "$BASE_URL/docs/"
    "$BASE_URL/examples/"
    "$BASE_URL/download/"
    "$BASE_URL/community/"
    "$BASE_URL/blog/"
)

for nav_link in "${NAV_LINKS[@]}"; do
    STATUS=$(check_link "$nav_link")
    
    if [ "$STATUS" -eq 200 ]; then
        print_status "Nav link working: $nav_link"
        if [[ ! " ${WORKING_LINKS[@]} " =~ " ${nav_link} " ]]; then
            ((WORKING_COUNT++))
            WORKING_LINKS+=("$nav_link")
        fi
    else
        print_error "Nav link broken ($STATUS): $nav_link"
        if [[ ! " ${BROKEN_LINKS[@]} " =~ " ${nav_link} " ]]; then
            ((BROKEN_COUNT++))
            BROKEN_LINKS+=("$nav_link")
        fi
    fi
done

echo ""
print_info "LINK ANALYSIS SUMMARY"
echo "===================="

echo "Total Links Analyzed: $TOTAL_LINKS"
echo "Working Internal Links: $WORKING_COUNT"
echo "Broken Internal Links: $BROKEN_COUNT"
echo "External Links: $EXTERNAL_COUNT"
echo ""

# Calculate coverage
if [ $TOTAL_LINKS -gt 0 ]; then
    COVERAGE=$((WORKING_COUNT * 100 / (WORKING_COUNT + BROKEN_COUNT)))
    echo "Link Coverage: ${COVERAGE}%"
    
    if [ $COVERAGE -ge 60 ]; then
        print_status "✅ COVERAGE TARGET MET: ${COVERAGE}% >= 60%"
    else
        print_warning "⚠️  COVERAGE BELOW TARGET: ${COVERAGE}% < 60%"
    fi
else
    print_error "No links found to analyze"
fi

echo ""
print_info "BROKEN LINKS REQUIRING ATTENTION"
echo "================================"

if [ ${#BROKEN_LINKS[@]} -eq 0 ]; then
    print_status "No broken links found!"
else
    for broken_link in "${BROKEN_LINKS[@]}"; do
        print_error "$broken_link"
    done
fi

echo ""
print_info "WORKING LINKS CONFIRMED"
echo "======================="

for working_link in "${WORKING_LINKS[@]}"; do
    print_status "$working_link"
done

echo ""
print_info "RECOMMENDATIONS"
echo "=============="

if [ $COVERAGE -lt 60 ]; then
    echo "1. Create missing pages for broken internal links"
    echo "2. Fix navigation menu links"
    echo "3. Add content for key sections (docs, download, community, blog)"
    echo "4. Verify all call-to-action buttons point to existing pages"
fi

if [ ${#BROKEN_LINKS[@]} -gt 0 ]; then
    echo "5. Priority broken links to fix:"
    for broken_link in "${BROKEN_LINKS[@]}"; do
        if [[ "$broken_link" == *"/docs/"* ]] || [[ "$broken_link" == *"/download/"* ]]; then
            echo "   HIGH: $broken_link"
        fi
    done
fi

echo ""
print_status "Link analysis complete!"
