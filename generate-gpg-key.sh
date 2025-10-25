#!/bin/bash

echo "🔐 Generating GPG Key for Maven Central Signing"
echo "=============================================="

# Generate GPG key batch file
cat > gpg-key-config << 'GPGEOF'
%echo Generating GPG key for AMCP Maven Central
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: AMCP Development Team
Name-Email: contact@amcp.dev
Expire-Date: 2y
Passphrase: CHANGE_THIS_PASSPHRASE
%commit
%echo GPG key generation complete
GPGEOF

echo "⚠️  IMPORTANT: Edit gpg-key-config and change the passphrase!"
echo "Then run: gpg --batch --generate-key gpg-key-config"
echo ""
echo "After key generation:"
echo "1. List keys: gpg --list-secret-keys --keyid-format LONG"
echo "2. Export public key: gpg --keyserver keyserver.ubuntu.com --send-keys YOUR_KEY_ID"
echo "3. Update settings.xml with your key ID and passphrase"
