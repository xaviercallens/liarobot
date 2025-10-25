#!/bin/bash

echo "🔧 Setting up Maven Central Authentication"
echo "=========================================="

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

# Create .m2 directory if it doesn't exist
mkdir -p ~/.m2

print_info "Creating authenticated Maven settings.xml..."

# Create settings.xml with provided credentials
cat > ~/.m2/settings.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
          http://maven.apache.org/xsd/settings-1.0.0.xsd">
    
    <servers>
        <server>
            <id>ossrh</id>
            <username>9v2ll7</username>
            <password>NTjvxvJGj3bSphjhHBwCo4X9dyoLyN9fm</password>
        </server>
    </servers>

    <profiles>
        <profile>
            <id>ossrh</id>
            <activation>
                <activeByDefault>true</activeByDefault>
            </activation>
            <properties>
                <gpg.executable>gpg</gpg.executable>
                <gpg.keyname>mew0hxcxhu</gpg.keyname>
                <gpg.passphrase></gpg.passphrase>
            </properties>
        </profile>
    </profiles>
</settings>
EOF

print_status "Maven settings.xml created with authentication"

# Set proper permissions
chmod 600 ~/.m2/settings.xml

print_status "Settings file permissions secured"

print_info "Checking GPG key availability..."

# Check if the specified GPG key exists
if gpg --list-secret-keys | grep -q "mew0hxcxhu"; then
    print_status "GPG key 'mew0hxcxhu' found in keyring"
else
    print_warning "GPG key 'mew0hxcxhu' not found in local keyring"
    print_info "You may need to import the key or generate a new one"
    print_info "To list available keys: gpg --list-secret-keys"
fi

print_info "Testing Maven Central connectivity..."

# Test connectivity to Maven Central
if curl -s --connect-timeout 10 https://s01.oss.sonatype.org/ > /dev/null; then
    print_status "Maven Central (Sonatype OSSRH) is accessible"
else
    print_warning "Unable to connect to Maven Central"
    print_info "Check your internet connection and firewall settings"
fi

echo ""
print_status "Maven Central authentication setup complete!"
echo ""
print_info "Configuration Summary:"
echo "  Username: 9v2ll7"
echo "  Server ID: ossrh"
echo "  GPG Key: mew0hxcxhu"
echo "  Settings: ~/.m2/settings.xml"
echo ""
print_info "Next steps:"
echo "1. Ensure GPG key 'mew0hxcxhu' is available and has a passphrase"
echo "2. Run: ./deploy-to-central-authenticated.sh"
echo "3. Monitor deployment progress in Sonatype Nexus"
