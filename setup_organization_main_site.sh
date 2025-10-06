#!/bin/bash

echo "🌐 Setting up AMCP Organization Main GitHub Pages Site"
echo "====================================================="
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

# Repository information
ORG_NAME="agentmeshcommunicationprotocol"
CURRENT_REPO="amcp.github.io"
MAIN_SITE_REPO="${ORG_NAME}.github.io"

print_info "Current repository: ${ORG_NAME}/${CURRENT_REPO}"
print_info "Required for main site: ${ORG_NAME}/${MAIN_SITE_REPO}"
echo ""

print_warning "ISSUE IDENTIFIED:"
echo "=================="
echo "For the organization main site to be available at:"
echo "https://${ORG_NAME}.github.io/"
echo ""
echo "The repository must be named:"
echo "${ORG_NAME}/${MAIN_SITE_REPO}"
echo ""
echo "Current repository name:"
echo "${ORG_NAME}/${CURRENT_REPO}"
echo ""

print_info "SOLUTION OPTIONS:"
echo "================="
echo ""

echo "🔄 Option 1: Rename Current Repository (Recommended)"
echo "---------------------------------------------------"
echo "1. Go to: https://github.com/${ORG_NAME}/${CURRENT_REPO}/settings"
echo "2. Scroll to 'Repository name' section"
echo "3. Change name from '${CURRENT_REPO}' to '${MAIN_SITE_REPO}'"
echo "4. Click 'Rename'"
echo ""
echo "After renaming:"
echo "• Main site will be: https://${ORG_NAME}.github.io/"
echo "• Repository will be: https://github.com/${ORG_NAME}/${MAIN_SITE_REPO}"
echo ""

echo "🆕 Option 2: Create New Repository"
echo "----------------------------------"
echo "1. Create new repository: ${ORG_NAME}/${MAIN_SITE_REPO}"
echo "2. Copy all content from current repository"
echo "3. Set up GitHub Pages on new repository"
echo "4. Update DNS and redirects"
echo ""

echo "🔧 Option 3: Use Custom Domain"
echo "------------------------------"
echo "1. Keep current repository name"
echo "2. Set up custom domain (e.g., amcp.dev)"
echo "3. Configure DNS records"
echo "4. Enable custom domain in GitHub Pages settings"
echo ""

print_info "RECOMMENDED APPROACH:"
echo "===================="
echo "Rename the current repository to '${MAIN_SITE_REPO}'"
echo "This is the simplest solution that will make the site available at:"
echo "https://${ORG_NAME}.github.io/"
echo ""

print_info "STEPS TO IMPLEMENT:"
echo "=================="
echo "1. 🌐 Go to repository settings"
echo "2. 📝 Rename repository to '${MAIN_SITE_REPO}'"
echo "3. 🔄 Update local remote URL"
echo "4. ✅ Verify site is accessible at root domain"
echo ""

print_info "AFTER RENAMING - UPDATE LOCAL REPOSITORY:"
echo "========================================"
echo "cd /home/kalxav/CascadeProjects/amcp-github-pages"
echo "git remote set-url origin git@github.com:${ORG_NAME}/${MAIN_SITE_REPO}.git"
echo "git remote -v  # Verify new URL"
echo ""

print_info "VERIFICATION COMMANDS:"
echo "===================="
echo "# Check if main site is live (after renaming)"
echo "curl -I https://${ORG_NAME}.github.io/"
echo ""
echo "# Check GitHub Pages status"
echo "curl -s https://api.github.com/repos/${ORG_NAME}/${MAIN_SITE_REPO}/pages"
echo ""

print_warning "IMPORTANT NOTES:"
echo "==============="
echo "• Renaming will update all existing links automatically"
echo "• GitHub will set up redirects from old repository name"
echo "• No content will be lost during the rename process"
echo "• All commit history will be preserved"
echo "• Collaborators will need to update their local remotes"
echo ""

print_status "CURRENT SITE STATUS:"
echo "==================="
echo "✅ Content: Ready and deployed"
echo "✅ Design: Modern Google-inspired theme"
echo "✅ Documentation: Complete and comprehensive"
echo "✅ Integration: Connected to amcp-core repository"
echo "⚠️  URL: Available at https://${ORG_NAME}.github.io/${CURRENT_REPO}/"
echo "❌ Main Site: Not available at https://${ORG_NAME}.github.io/"
echo ""

print_info "NEXT STEPS:"
echo "=========="
echo "1. Rename repository to '${MAIN_SITE_REPO}' via GitHub web interface"
echo "2. Update local remote URL using the command above"
echo "3. Verify main site is accessible at https://${ORG_NAME}.github.io/"
echo "4. Update any documentation that references the old repository name"
echo ""

print_status "🎯 SOLUTION READY - REPOSITORY RENAME REQUIRED!"
echo ""
echo "Repository Settings URL:"
echo "https://github.com/${ORG_NAME}/${CURRENT_REPO}/settings"
echo ""
print_status "🌟 After renaming, the AMCP main site will be live at the root domain!"
