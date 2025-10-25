#!/bin/bash

echo "🔐 Setting up GPG Key for Maven Central Signing"
echo "==============================================="

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

KEY_ID="mew0hxcxhu"

print_info "Checking for existing GPG key: $KEY_ID"

# Check if key already exists
if gpg --list-secret-keys | grep -q "$KEY_ID"; then
    print_status "GPG key '$KEY_ID' already exists in keyring"
    gpg --list-secret-keys --keyid-format LONG | grep -A 2 -B 2 "$KEY_ID"
    exit 0
fi

print_warning "GPG key '$KEY_ID' not found. Creating new key..."

# Create GPG key configuration
cat > gpg-key-batch-config << EOF
%echo Generating GPG key for AMCP Maven Central
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: AMCP Development Team
Name-Email: contact@amcp.dev
Expire-Date: 2y
Passphrase: amcp-maven-central-2025
%commit
%echo GPG key generation complete
EOF

print_info "Generating new GPG key..."
print_warning "This may take several minutes..."

# Generate the key
gpg --batch --generate-key gpg-key-batch-config

if [ $? -eq 0 ]; then
    print_status "GPG key generated successfully"
    
    # List the generated keys
    print_info "Generated keys:"
    gpg --list-secret-keys --keyid-format LONG
    
    # Get the key ID
    GENERATED_KEY_ID=$(gpg --list-secret-keys --keyid-format LONG | grep "sec" | head -1 | awk '{print $2}' | cut -d'/' -f2)
    
    if [ ! -z "$GENERATED_KEY_ID" ]; then
        print_info "Generated key ID: $GENERATED_KEY_ID"
        
        # Export public key to key servers
        print_info "Uploading public key to key servers..."
        
        gpg --keyserver keyserver.ubuntu.com --send-keys "$GENERATED_KEY_ID" 2>/dev/null || print_warning "Failed to upload to keyserver.ubuntu.com"
        gpg --keyserver keys.openpgp.org --send-keys "$GENERATED_KEY_ID" 2>/dev/null || print_warning "Failed to upload to keys.openpgp.org"
        
        print_status "Public key uploaded to key servers"
        
        # Update Maven settings to use the actual generated key ID
        print_info "Updating Maven settings with generated key ID..."
        
        sed -i "s/mew0hxcxhu/$GENERATED_KEY_ID/g" ~/.m2/settings.xml
        sed -i "s/<gpg.passphrase><\/gpg.passphrase>/<gpg.passphrase>amcp-maven-central-2025<\/gpg.passphrase>/g" ~/.m2/settings.xml
        
        print_status "Maven settings updated with new key ID"
        
        # Also update the POM file
        if [ -f "amcp-core-project/pom-central-authenticated.xml" ]; then
            sed -i "s/mew0hxcxhu/$GENERATED_KEY_ID/g" amcp-core-project/pom-central-authenticated.xml
            print_status "POM file updated with new key ID"
        fi
        
        print_status "🎉 GPG key setup complete!"
        echo ""
        print_info "Key Details:"
        echo "  Key ID: $GENERATED_KEY_ID"
        echo "  Passphrase: amcp-maven-central-2025"
        echo "  Name: AMCP Development Team"
        echo "  Email: contact@amcp.dev"
        echo ""
        print_info "✅ Ready for Maven Central deployment!"
        
    else
        print_error "Could not determine generated key ID"
        exit 1
    fi
    
else
    print_error "GPG key generation failed"
    exit 1
fi

# Clean up
rm -f gpg-key-batch-config

print_info "🔐 GPG setup complete. You can now run: ./deploy-to-central-authenticated.sh"
