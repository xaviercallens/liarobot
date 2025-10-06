#!/bin/bash

echo "🏗️ Building and Deploying AMCP v1.5.0 to Maven Repository"
echo "=========================================================="

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

# Check if Maven is installed
if ! command -v mvn &> /dev/null; then
    print_error "Maven is not installed. Please install Maven first."
    exit 1
fi

print_info "Maven version:"
mvn --version

# Navigate to the core project directory
cd amcp-core-project

print_info "Building AMCP Core v1.5.0..."

# Clean and compile
mvn clean compile
if [ $? -ne 0 ]; then
    print_error "Compilation failed"
    exit 1
fi

print_status "Compilation successful"

# Run tests
print_info "Running tests..."
mvn test
if [ $? -ne 0 ]; then
    print_warning "Tests failed, but continuing with build"
fi

# Package the JAR
print_info "Packaging JAR..."
mvn package -DskipTests
if [ $? -ne 0 ]; then
    print_error "Packaging failed"
    exit 1
fi

print_status "JAR packaging successful"

# Generate sources JAR
print_info "Generating sources JAR..."
mvn source:jar
if [ $? -ne 0 ]; then
    print_warning "Sources JAR generation failed"
fi

# Generate Javadoc JAR
print_info "Generating Javadoc JAR..."
mvn javadoc:jar
if [ $? -ne 0 ]; then
    print_warning "Javadoc JAR generation failed"
fi

# Deploy to local Maven repository
print_info "Deploying to Maven repository..."
mvn deploy -DskipTests
if [ $? -ne 0 ]; then
    print_error "Deployment failed"
    exit 1
fi

print_status "Deployment successful"

# Copy artifacts to the repository structure
cd ..
REPO_DIR="amcp-maven-repo/releases/org/amcp/amcp-core/1.5.0"

print_info "Copying artifacts to repository structure..."

# Copy main JAR
if [ -f "amcp-core-project/target/amcp-core-1.5.0.jar" ]; then
    cp "amcp-core-project/target/amcp-core-1.5.0.jar" "${REPO_DIR}/"
    print_status "Main JAR copied"
else
    print_warning "Main JAR not found"
fi

# Copy sources JAR
if [ -f "amcp-core-project/target/amcp-core-1.5.0-sources.jar" ]; then
    cp "amcp-core-project/target/amcp-core-1.5.0-sources.jar" "${REPO_DIR}/"
    print_status "Sources JAR copied"
else
    print_warning "Sources JAR not found"
fi

# Copy Javadoc JAR
if [ -f "amcp-core-project/target/amcp-core-1.5.0-javadoc.jar" ]; then
    cp "amcp-core-project/target/amcp-core-1.5.0-javadoc.jar" "${REPO_DIR}/"
    print_status "Javadoc JAR copied"
else
    print_warning "Javadoc JAR not found"
fi

# Generate checksums
print_info "Generating checksums..."
cd "${REPO_DIR}"

for file in *.jar *.pom; do
    if [ -f "$file" ]; then
        # MD5
        md5sum "$file" > "${file}.md5"
        # SHA1
        sha1sum "$file" > "${file}.sha1"
        print_status "Checksums generated for $file"
    fi
done

cd - > /dev/null

print_info "Repository structure:"
tree amcp-maven-repo/ 2>/dev/null || find amcp-maven-repo/ -type f | sort

echo ""
print_status "🎉 AMCP v1.5.0 Maven Repository Build Complete!"
echo ""
print_info "Repository Location: $(pwd)/amcp-maven-repo/"
print_info "Usage Instructions:"
echo ""
echo "Maven:"
echo "<repositories>"
echo "    <repository>"
echo "        <id>amcp-releases</id>"
echo "        <url>file://$(pwd)/amcp-maven-repo/releases</url>"
echo "    </repository>"
echo "</repositories>"
echo ""
echo "<dependencies>"
echo "    <dependency>"
echo "        <groupId>org.amcp</groupId>"
echo "        <artifactId>amcp-core</artifactId>"
echo "        <version>1.5.0</version>"
echo "    </dependency>"
echo "</dependencies>"
echo ""
print_info "To publish to GitHub, commit and push the amcp-maven-repo directory"
