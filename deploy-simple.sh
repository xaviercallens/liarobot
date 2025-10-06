#!/bin/bash

echo "🚀 Simple Maven Central Deployment for AMCP Core v1.5.0"
echo "========================================================"

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

cd amcp-core-project

# Use the authenticated POM
cp pom-central-authenticated.xml pom.xml

print_info "Building project..."

# Clean build
mvn clean compile test

if [ $? -ne 0 ]; then
    print_error "Build failed"
    exit 1
fi

print_status "Build successful"

print_info "Deploying directly to Maven Central..."

# Deploy with all required artifacts
mvn clean deploy -P ossrh -Dgpg.passphrase=amcp-maven-central-2025

DEPLOY_STATUS=$?

if [ $DEPLOY_STATUS -eq 0 ]; then
    print_status "🎉 Successfully deployed to Maven Central!"
    echo ""
    print_info "🌐 Deployment Details:"
    echo "  Repository: Sonatype OSSRH"
    echo "  Group ID: org.amcp"
    echo "  Artifact ID: amcp-core"
    echo "  Version: 1.5.0"
    echo ""
    print_info "📦 Maven Coordinates:"
    echo "  <dependency>"
    echo "    <groupId>org.amcp</groupId>"
    echo "    <artifactId>amcp-core</artifactId>"
    echo "    <version>1.5.0</version>"
    echo "  </dependency>"
    echo ""
    print_info "🔍 Verification:"
    echo "  Run: ./verify-maven-central.sh"
    echo "  Or visit: https://repo1.maven.org/maven2/org/amcp/amcp-core/1.5.0/"
    echo ""
    print_warning "⏰ Note: It may take 2-4 hours for artifacts to appear in Maven Central"
    
else
    print_error "Deployment failed with exit code: $DEPLOY_STATUS"
    print_info "Check the Maven output above for details"
    exit 1
fi

print_status "🎊 AMCP Core v1.5.0 deployment completed!"
