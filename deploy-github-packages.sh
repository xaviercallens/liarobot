#!/bin/bash

echo "🚀 Deploying AMCP Core v1.5.0 to GitHub Packages"
echo "================================================"

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

# GitHub configuration
GITHUB_OWNER="agentmeshcommunicationprotocol"
GITHUB_REPO="amcpcore.github.io"
GITHUB_PACKAGES_URL="https://maven.pkg.github.com/${GITHUB_OWNER}/${GITHUB_REPO}"

print_info "Preparing AMCP Core v1.5.0 for GitHub Packages deployment..."

# Create GitHub Packages compatible POM
cd amcp-core-project

print_info "Creating GitHub Packages compatible POM..."

cat > pom-github-packages.xml << 'EOF'
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
        </plugins>
    </build>

    <distributionManagement>
        <repository>
            <id>github</id>
            <name>GitHub Packages</name>
            <url>https://maven.pkg.github.com/agentmeshcommunicationprotocol/amcpcore.github.io</url>
        </repository>
    </distributionManagement>
</project>
EOF

print_status "GitHub Packages POM created"

# Use the GitHub Packages POM
cp pom-github-packages.xml pom.xml

print_info "Building project for GitHub Packages..."

# Clean build
mvn clean compile test

if [ $? -ne 0 ]; then
    print_error "Build failed"
    exit 1
fi

print_status "Build successful"

print_info "Creating GitHub Packages deployment instructions..."

# Create deployment instructions
cat > ../GITHUB_PACKAGES_DEPLOYMENT.md << 'EOF'
# 🚀 GitHub Packages Deployment for AMCP Core v1.5.0

## 📋 **Prerequisites**

### **GitHub Personal Access Token Required**
To deploy to GitHub Packages, you need a GitHub Personal Access Token with `write:packages` permission.

### **Create Token:**
1. Go to: https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Select scopes:
   - ✅ `write:packages` (Upload packages to GitHub Package Registry)
   - ✅ `read:packages` (Download packages from GitHub Package Registry)
   - ✅ `repo` (Full control of private repositories)
4. Copy the generated token

### **Configure Maven Settings**
Add to `~/.m2/settings.xml`:

```xml
<servers>
    <server>
        <id>github</id>
        <username>YOUR_GITHUB_USERNAME</username>
        <password>YOUR_GITHUB_TOKEN</password>
    </server>
</servers>
```

## 🚀 **Deployment Commands**

### **Deploy to GitHub Packages:**
```bash
cd amcp-core-project
mvn deploy
```

### **Expected Output:**
```
[INFO] Uploading to github: https://maven.pkg.github.com/agentmeshcommunicationprotocol/amcpcore.github.io/org/amcp/amcp-core/1.5.0/amcp-core-1.5.0.pom
[INFO] Uploaded to github: https://maven.pkg.github.com/agentmeshcommunicationprotocol/amcpcore.github.io/org/amcp/amcp-core/1.5.0/amcp-core-1.5.0.pom (4.1 kB at 2.8 kB/s)
[INFO] Uploading to github: https://maven.pkg.github.com/agentmeshcommunicationprotocol/amcpcore.github.io/org/amcp/amcp-core/1.5.0/amcp-core-1.5.0.jar
[INFO] Uploaded to github: https://maven.pkg.github.com/agentmeshcommunicationprotocol/amcpcore.github.io/org/amcp/amcp-core/1.5.0/amcp-core-1.5.0.jar (13 kB at 8.9 kB/s)
[INFO] BUILD SUCCESS
```

## 📦 **Usage Instructions**

### **For Developers Using AMCP:**

#### **Maven Configuration:**
```xml
<repositories>
    <repository>
        <id>github</id>
        <url>https://maven.pkg.github.com/agentmeshcommunicationprotocol/amcpcore.github.io</url>
    </repository>
</repositories>

<dependency>
    <groupId>org.amcp</groupId>
    <artifactId>amcp-core</artifactId>
    <version>1.5.0</version>
</dependency>
```

#### **Gradle Configuration:**
```gradle
repositories {
    maven {
        url = uri("https://maven.pkg.github.com/agentmeshcommunicationprotocol/amcpcore.github.io")
        credentials {
            username = project.findProperty("gpr.user") ?: System.getenv("USERNAME")
            password = project.findProperty("gpr.key") ?: System.getenv("TOKEN")
        }
    }
}

dependencies {
    implementation 'org.amcp:amcp-core:1.5.0'
}
```

#### **Authentication for Users:**
Users need to authenticate to access GitHub Packages:

**Option 1: Maven settings.xml**
```xml
<servers>
    <server>
        <id>github</id>
        <username>GITHUB_USERNAME</username>
        <password>GITHUB_TOKEN</password>
    </server>
</servers>
```

**Option 2: Environment Variables**
```bash
export USERNAME=your-github-username
export TOKEN=your-github-token
```

## 🌐 **Verification**

### **Check Package Availability:**
1. Go to: https://github.com/agentmeshcommunicationprotocol/amcpcore.github.io/packages
2. Verify `amcp-core` package is listed
3. Check version 1.5.0 is available

### **Test Integration:**
Create a test project and add the dependency to verify it resolves correctly.

## ✅ **Benefits of GitHub Packages**

- **✅ Immediate Availability**: No approval process required
- **✅ Professional Distribution**: Standard Maven coordinates
- **✅ Integrated with Repository**: Linked to source code
- **✅ Version Management**: Automatic versioning and releases
- **✅ Access Control**: Fine-grained permissions
- **✅ CDN Distribution**: Fast global access via GitHub's CDN

## 🎯 **Next Steps**

1. **Deploy to GitHub Packages** (immediate availability)
2. **Update Documentation** with GitHub Packages coordinates
3. **Continue Maven Central Resolution** (for broader accessibility)
4. **Dual Distribution** once Maven Central is resolved

EOF

print_status "GitHub Packages deployment guide created"

print_info "🎯 GITHUB PACKAGES DEPLOYMENT READY"
echo "===================================="
echo ""
print_info "📋 Next Steps Required:"
echo "1. 🔑 Create GitHub Personal Access Token with 'write:packages' permission"
echo "2. ⚙️  Configure ~/.m2/settings.xml with GitHub credentials"
echo "3. 🚀 Run: mvn deploy (from amcp-core-project directory)"
echo ""
print_info "📖 Complete instructions available in:"
echo "  ../GITHUB_PACKAGES_DEPLOYMENT.md"
echo ""
print_info "🌐 After deployment, AMCP will be available at:"
echo "  https://maven.pkg.github.com/agentmeshcommunicationprotocol/amcpcore.github.io"
echo ""
print_status "✅ GitHub Packages deployment preparation complete!"
echo ""
print_warning "⚠️  Note: GitHub Packages requires authentication for both publishing and consuming"
print_info "This is more secure but requires users to set up GitHub tokens"
print_info "Consider this alongside the existing self-hosted Maven repository for broader access"
