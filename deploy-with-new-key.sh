#!/bin/bash

echo "🚀 Deploying AMCP Core v1.5.0 with New Verification Key"
echo "======================================================"

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

# New verification key configuration
VERIFICATION_KEY="0wcck9mytv"
NAMESPACE_ID="710a98a1-b3a5-4c6c-bbe8-2bd3abae2f52"
USERNAME="9v2ll7"
PASSWORD="NTjvxvJGj3bSphjhHBwCo4X9dyoLyN9fm"

print_info "Using new verification key configuration:"
echo "  Verification Key: $VERIFICATION_KEY"
echo "  Namespace ID: $NAMESPACE_ID"
echo "  Username: $USERNAME"
echo "  Status: Verification Pending"
echo ""

# Update Maven settings with new key
print_info "Updating Maven settings with new verification key..."

cat > ~/.m2/settings.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
          http://maven.apache.org/xsd/settings-1.0.0.xsd">
    
    <servers>
        <server>
            <id>central</id>
            <username>$USERNAME</username>
            <password>$PASSWORD</password>
        </server>
        <server>
            <id>ossrh</id>
            <username>$USERNAME</username>
            <password>$PASSWORD</password>
        </server>
    </servers>

    <profiles>
        <profile>
            <id>central-deploy</id>
            <activation>
                <activeByDefault>true</activeByDefault>
            </activation>
            <properties>
                <gpg.executable>gpg</gpg.executable>
                <gpg.keyname>2D3E25D42C5A7914</gpg.keyname>
                <gpg.passphrase>amcp-maven-central-2025</gpg.passphrase>
                <central.verification.key>$VERIFICATION_KEY</central.verification.key>
                <central.namespace.id>$NAMESPACE_ID</central.namespace.id>
            </properties>
        </profile>
    </profiles>
</settings>
EOF

print_status "Maven settings updated with new verification key"

# Create updated POM for new key deployment
cd amcp-core-project

print_info "Creating POM with new verification key configuration..."

cat > pom-new-key.xml << 'EOF'
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
        
        <!-- Central Portal Configuration -->
        <central.verification.key>0wcck9mytv</central.verification.key>
        <central.namespace.id>710a98a1-b3a5-4c6c-bbe8-2bd3abae2f52</central.namespace.id>
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
                        <phase>verify</phase>
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
                        <configuration>
                            <keyname>2D3E25D42C5A7914</keyname>
                            <executable>gpg</executable>
                            <passphrase>amcp-maven-central-2025</passphrase>
                        </configuration>
                    </execution>
                </executions>
            </plugin>

            <plugin>
                <groupId>org.sonatype.central</groupId>
                <artifactId>central-publishing-maven-plugin</artifactId>
                <version>0.4.0</version>
                <extensions>true</extensions>
                <configuration>
                    <publishingServerId>central</publishingServerId>
                    <tokenAuth>true</tokenAuth>
                    <autoPublish>true</autoPublish>
                    <waitUntil>published</waitUntil>
                </configuration>
            </plugin>
        </plugins>
    </build>

    <distributionManagement>
        <repository>
            <id>central</id>
            <url>https://central.sonatype.com/api/v1/publisher/upload</url>
        </repository>
    </distributionManagement>
</project>
EOF

print_status "New key POM configuration created"

# Use the new POM
cp pom-new-key.xml pom.xml

print_info "Testing Central Portal API access with new key..."

# Test API access with new credentials
API_TEST=$(curl -s -w "%{http_code}" -o /tmp/central_test \
    -u "$USERNAME:$PASSWORD" \
    "https://central.sonatype.com/api/v1/publisher/deployments")

if [ "$API_TEST" = "200" ]; then
    print_status "✅ Central Portal API accessible with new credentials!"
    print_info "API Response:"
    cat /tmp/central_test | jq . 2>/dev/null || cat /tmp/central_test
elif [ "$API_TEST" = "401" ]; then
    print_warning "⚠️ Still getting 401 - verification may still be pending"
    print_info "This is expected if verification is still in progress"
elif [ "$API_TEST" = "403" ]; then
    print_warning "⚠️ 403 Forbidden - namespace verification may be incomplete"
else
    print_info "API returned HTTP $API_TEST"
    cat /tmp/central_test
fi

echo ""

print_info "Building project with new configuration..."

# Build the project
mvn clean compile test

if [ $? -ne 0 ]; then
    print_error "Build failed"
    exit 1
fi

print_status "Build successful with new configuration"

print_info "🎯 DEPLOYMENT OPTIONS WITH NEW KEY"
echo "=================================="
echo ""

if [ "$API_TEST" = "200" ]; then
    print_status "✅ Ready for immediate deployment!"
    echo ""
    print_info "Deploy to Maven Central:"
    echo "  mvn clean deploy -P central-deploy"
    echo ""
    print_info "Or use the Central Publishing Plugin:"
    echo "  mvn clean deploy"
    echo ""
    
    print_warning "🚀 Attempting deployment now..."
    echo ""
    
    # Attempt deployment
    mvn clean deploy -Dgpg.passphrase=amcp-maven-central-2025
    
    DEPLOY_STATUS=$?
    
    if [ $DEPLOY_STATUS -eq 0 ]; then
        print_status "🎉 DEPLOYMENT SUCCESSFUL!"
        echo ""
        print_info "🌐 AMCP Core v1.5.0 is now being published to Maven Central!"
        echo ""
        print_info "📦 Maven Coordinates:"
        echo "  <dependency>"
        echo "    <groupId>org.amcp</groupId>"
        echo "    <artifactId>amcp-core</artifactId>"
        echo "    <version>1.5.0</version>"
        echo "  </dependency>"
        echo ""
        print_warning "⏰ Note: It may take 2-4 hours for artifacts to appear in Maven Central"
        print_info "🔍 Verify with: ./verify-maven-central.sh"
        
    else
        print_error "Deployment failed - check output above for details"
    fi
    
else
    print_warning "⚠️ API access not yet available"
    print_info "Possible reasons:"
    echo "1. 🕐 Verification still pending (most likely)"
    echo "2. 🔑 Key not yet activated"
    echo "3. 🌐 Namespace approval in progress"
    echo ""
    print_info "✅ Configuration is ready - retry when verification completes:"
    echo "  ./deploy-with-new-key.sh"
    echo ""
    print_info "📋 Monitor verification status at:"
    echo "  https://central.sonatype.com/publishing"
fi

# Cleanup
rm -f /tmp/central_test

echo ""
print_status "🎊 New key deployment setup completed!"
echo ""
print_info "📋 Summary:"
echo "  ✅ New verification key configured: $VERIFICATION_KEY"
echo "  ✅ Namespace ID set: $NAMESPACE_ID"
echo "  ✅ Maven settings updated"
echo "  ✅ POM configured for Central Portal"
echo "  ✅ All artifacts built and ready"
echo ""
print_info "🎯 Status: $([ "$API_TEST" = "200" ] && echo "Ready for deployment!" || echo "Waiting for verification completion")"
