#!/bin/bash

echo "🚀 Setting up AMCP Maven Repository on GitHub"
echo "============================================="

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

# Navigate to the Maven repository directory
cd amcp-maven-repo

# Initialize git repository
print_info "Initializing Git repository..."
git init
git branch -M main

# Add all files
print_info "Adding files to Git..."
git add .

# Create initial commit
print_info "Creating initial commit..."
git commit -m "feat: Initial AMCP v1.5.0 Maven repository

## 📦 AMCP Core v1.5.0 Release

### ✅ Maven Artifacts
- **Group ID**: org.amcp
- **Artifact ID**: amcp-core  
- **Version**: 1.5.0
- **Packaging**: JAR with sources and javadoc

### 📚 Included Artifacts
- amcp-core-1.5.0.jar (13KB) - Main library
- amcp-core-1.5.0-sources.jar (7.5KB) - Source code
- amcp-core-1.5.0-javadoc.jar (116KB) - API documentation
- amcp-core-1.5.0.pom (3.9KB) - Maven project descriptor

### 🔐 Security
- MD5 and SHA1 checksums for all artifacts
- Maven metadata.xml files for version management

### 🚀 Core Features
- Agent base class with lifecycle management
- Event-driven communication system
- Agent context for mesh interaction
- Comprehensive logging and metadata support
- Type-safe event payload handling

### 📖 Usage
Add to your Maven pom.xml:
\`\`\`xml
<repositories>
    <repository>
        <id>amcp-releases</id>
        <url>https://raw.githubusercontent.com/agentmeshcommunicationprotocol/amcp-maven-repo/main/releases</url>
    </repository>
</repositories>

<dependencies>
    <dependency>
        <groupId>org.amcp</groupId>
        <artifactId>amcp-core</artifactId>
        <version>1.5.0</version>
    </dependency>
</dependencies>
\`\`\`

This repository provides the foundation for building distributed
agent systems with the Agent Mesh Communication Protocol."

print_status "Git repository initialized and committed"

print_info "Repository is ready for GitHub!"
print_warning "Next steps:"
echo "1. Create a new repository on GitHub: 'amcp-maven-repo'"
echo "2. Add the remote origin:"
echo "   git remote add origin https://github.com/agentmeshcommunicationprotocol/amcp-maven-repo.git"
echo "3. Push to GitHub:"
echo "   git push -u origin main"
echo ""
print_info "After pushing, the repository will be accessible at:"
echo "https://raw.githubusercontent.com/agentmeshcommunicationprotocol/amcp-maven-repo/main/releases"

# Show repository status
print_info "Repository status:"
git status
git log --oneline

print_status "🎉 AMCP Maven Repository setup complete!"
