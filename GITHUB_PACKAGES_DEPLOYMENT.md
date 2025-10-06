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

