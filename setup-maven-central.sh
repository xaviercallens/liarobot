#!/bin/bash

echo "🚀 Setting up AMCP Core v1.5.0 for Maven Central Repository"
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

print_info "Preparing AMCP Core for Maven Central deployment..."
echo ""

# Check if GPG is available
if ! command -v gpg &> /dev/null; then
    print_error "GPG is not installed. Please install GPG first."
    print_info "Ubuntu/Debian: sudo apt-get install gnupg"
    print_info "macOS: brew install gnupg"
    exit 1
fi

print_status "GPG is available"

# Create Maven Central compatible POM
print_info "Creating Maven Central compatible POM..."

cat > amcp-core-project/pom-central.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.amcp</groupId>
    <artifactId>amcp-core</artifactId>
    <version>1.5.0</version>
    <packaging>jar</packaging>

    <name>AMCP Core</name>
    <description>Agent Mesh Communication Protocol - Core Framework for building distributed agent systems</description>
    <url>https://agentmeshcommunicationprotocol.github.io</url>

    <licenses>
        <license>
            <name>Apache License, Version 2.0</name>
            <url>http://www.apache.org/licenses/LICENSE-2.0.txt</url>
            <distribution>repo</distribution>
        </license>
    </licenses>

    <developers>
        <developer>
            <id>amcp-team</id>
            <name>AMCP Development Team</name>
            <email>contact@amcp.dev</email>
            <organization>Agent Mesh Communication Protocol</organization>
            <organizationUrl>https://agentmeshcommunicationprotocol.github.io</organizationUrl>
        </developer>
    </developers>

    <scm>
        <connection>scm:git:git://github.com/agentmeshcommunicationprotocol/amcpcore.github.io.git</connection>
        <developerConnection>scm:git:ssh://github.com:agentmeshcommunicationprotocol/amcpcore.github.io.git</developerConnection>
        <url>https://github.com/agentmeshcommunicationprotocol/amcpcore.github.io/tree/main</url>
    </scm>

    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        
        <!-- Dependency versions -->
        <jackson.version>2.15.2</jackson.version>
        <slf4j.version>2.0.9</slf4j.version>
        <junit.version>5.10.0</junit.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>com.fasterxml.jackson.core</groupId>
            <artifactId>jackson-databind</artifactId>
            <version>${jackson.version}</version>
        </dependency>
        
        <dependency>
            <groupId>com.fasterxml.jackson.datatype</groupId>
            <artifactId>jackson-datatype-jsr310</artifactId>
            <version>${jackson.version}</version>
        </dependency>

        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-api</artifactId>
            <version>${slf4j.version}</version>
        </dependency>

        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <version>${junit.version}</version>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.11.0</version>
                <configuration>
                    <source>17</source>
                    <target>17</target>
                </configuration>
            </plugin>

            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-source-plugin</artifactId>
                <version>3.3.0</version>
                <executions>
                    <execution>
                        <id>attach-sources</id>
                        <goals>
                            <goal>jar-no-fork</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>

            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-javadoc-plugin</artifactId>
                <version>3.6.0</version>
                <executions>
                    <execution>
                        <id>attach-javadocs</id>
                        <goals>
                            <goal>jar</goal>
                        </goals>
                    </execution>
                </executions>
                <configuration>
                    <source>17</source>
                    <doclint>none</doclint>
                </configuration>
            </plugin>

            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-gpg-plugin</artifactId>
                <version>3.1.0</version>
                <executions>
                    <execution>
                        <id>sign-artifacts</id>
                        <phase>verify</phase>
                        <goals>
                            <goal>sign</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>

            <plugin>
                <groupId>org.sonatype.plugins</groupId>
                <artifactId>nexus-staging-maven-plugin</artifactId>
                <version>1.6.13</version>
                <extensions>true</extensions>
                <configuration>
                    <serverId>ossrh</serverId>
                    <nexusUrl>https://s01.oss.sonatype.org/</nexusUrl>
                    <autoReleaseAfterClose>true</autoReleaseAfterClose>
                </configuration>
            </plugin>
        </plugins>
    </build>

    <distributionManagement>
        <snapshotRepository>
            <id>ossrh</id>
            <url>https://s01.oss.sonatype.org/content/repositories/snapshots</url>
        </snapshotRepository>
        <repository>
            <id>ossrh</id>
            <url>https://s01.oss.sonatype.org/service/local/staging/deploy/maven2/</url>
        </repository>
    </distributionManagement>
</project>
EOF

print_status "Maven Central POM created"

# Create settings.xml template
print_info "Creating Maven settings template..."

mkdir -p ~/.m2

cat > ~/.m2/settings-central-template.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
          http://maven.apache.org/xsd/settings-1.0.0.xsd">
    
    <servers>
        <server>
            <id>ossrh</id>
            <username>YOUR_SONATYPE_USERNAME</username>
            <password>YOUR_SONATYPE_PASSWORD</password>
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
                <gpg.keyname>YOUR_GPG_KEY_ID</gpg.keyname>
                <gpg.passphrase>YOUR_GPG_PASSPHRASE</gpg.passphrase>
            </properties>
        </profile>
    </profiles>
</settings>
EOF

print_status "Maven settings template created"

print_info "Creating GPG key generation script..."

cat > generate-gpg-key.sh << 'EOF'
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
EOF

chmod +x generate-gpg-key.sh

print_status "GPG key generation script created"

print_info "Creating deployment script..."

cat > deploy-to-central.sh << 'EOF'
#!/bin/bash

echo "🚀 Deploying AMCP Core v1.5.0 to Maven Central"
echo "=============================================="

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

# Check prerequisites
print_info "Checking prerequisites..."

if [ ! -f ~/.m2/settings.xml ]; then
    print_error "Maven settings.xml not found!"
    print_info "Please configure ~/.m2/settings.xml with your Sonatype credentials"
    print_info "Use the template: ~/.m2/settings-central-template.xml"
    exit 1
fi

if ! gpg --list-secret-keys | grep -q "sec"; then
    print_error "No GPG secret key found!"
    print_info "Please generate a GPG key first using: ./generate-gpg-key.sh"
    exit 1
fi

print_status "Prerequisites check passed"

# Navigate to project directory
cd amcp-core-project

# Use the Maven Central POM
cp pom-central.xml pom.xml

print_info "Building and signing artifacts..."

# Clean and build
mvn clean compile test

if [ $? -ne 0 ]; then
    print_error "Build failed"
    exit 1
fi

print_status "Build successful"

# Deploy to staging repository
print_info "Deploying to Maven Central staging repository..."

mvn deploy -P ossrh

if [ $? -eq 0 ]; then
    print_status "🎉 Deployment to staging successful!"
    echo ""
    print_info "Next steps:"
    echo "1. Go to: https://s01.oss.sonatype.org/"
    echo "2. Login with your Sonatype credentials"
    echo "3. Go to 'Staging Repositories'"
    echo "4. Find your org.amcp repository"
    echo "5. Select it and click 'Close'"
    echo "6. Wait for validation to complete"
    echo "7. Click 'Release' to publish to Maven Central"
    echo ""
    print_info "After release, artifacts will be available at:"
    echo "  https://repo1.maven.org/maven2/org/amcp/amcp-core/1.5.0/"
    echo ""
    print_warning "Note: It can take 2-4 hours for artifacts to appear in Maven Central"
else
    print_error "Deployment failed"
    print_info "Check the error messages above and verify:"
    echo "1. Sonatype credentials are correct"
    echo "2. GPG key is properly configured"
    echo "3. All required artifacts are signed"
fi
EOF

chmod +x deploy-to-central.sh

print_status "Deployment script created"

echo ""
print_info "MAVEN CENTRAL SETUP COMPLETE"
echo "============================"
echo ""
print_warning "IMPORTANT: Manual steps required before deployment:"
echo ""
echo "1. 📝 SONATYPE ACCOUNT SETUP"
echo "   - Create account at: https://issues.sonatype.org/secure/Signup!default.jspa"
echo "   - Create JIRA ticket to claim org.amcp group ID"
echo "   - Wait for approval (usually 1-2 business days)"
echo ""
echo "2. 🔐 GPG KEY SETUP"
echo "   - Edit gpg-key-config and set a secure passphrase"
echo "   - Run: ./generate-gpg-key.sh"
echo "   - Follow the GPG key generation instructions"
echo ""
echo "3. ⚙️  MAVEN CONFIGURATION"
echo "   - Copy ~/.m2/settings-central-template.xml to ~/.m2/settings.xml"
echo "   - Update with your Sonatype username/password"
echo "   - Update with your GPG key ID and passphrase"
echo ""
echo "4. 🚀 DEPLOYMENT"
echo "   - Run: ./deploy-to-central.sh"
echo "   - Follow the staging repository instructions"
echo ""
print_info "Detailed instructions available in MAVEN_CENTRAL_GUIDE.md"
print_status "Setup complete! Ready for Maven Central deployment."
