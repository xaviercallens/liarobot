# 🚀 Maven Central Deployment Guide for AMCP Core v1.5.0

## 📋 **Complete Guide to Publishing on Maven Central**

This guide will walk you through the entire process of publishing AMCP Core v1.5.0 to Maven Central Repository, making it available worldwide via standard Maven coordinates.

---

## 🎯 **Final Goal**

After completion, developers worldwide will be able to use AMCP with:

```xml
<dependency>
    <groupId>org.amcp</groupId>
    <artifactId>amcp-core</artifactId>
    <version>1.5.0</version>
</dependency>
```

---

## 📋 **Prerequisites & Setup Process**

### **Step 1: Sonatype OSSRH Account Setup**

#### **1.1 Create Sonatype Account**
1. Go to: https://issues.sonatype.org/secure/Signup!default.jspa
2. Create an account with your email
3. Verify your email address

#### **1.2 Request Group ID (org.amcp)**
1. Create a new JIRA ticket: https://issues.sonatype.org/secure/CreateIssue.jspa?issuetype=21&pid=10134
2. Fill out the form:
   - **Project**: Community Support - Open Source Project Repository Hosting (OSSRH)
   - **Issue Type**: New Project
   - **Summary**: Request for org.amcp group ID
   - **Group Id**: org.amcp
   - **Project URL**: https://agentmeshcommunicationprotocol.github.io
   - **SCM URL**: https://github.com/agentmeshcommunicationprotocol/amcpcore.github.io
   - **Description**: 
     ```
     Request to publish AMCP (Agent Mesh Communication Protocol) Core library to Maven Central.
     
     AMCP is an open-source framework for building distributed agent systems with event-driven 
     communication. The project provides enterprise-grade tools for multi-agent coordination 
     and is licensed under Apache 2.0.
     
     Project website: https://agentmeshcommunicationprotocol.github.io
     GitHub repository: https://github.com/agentmeshcommunicationprotocol/amcpcore.github.io
     
     We request the org.amcp group ID to publish our core library and future modules.
     ```

#### **1.3 Domain Verification**
- Sonatype will ask you to verify domain ownership
- Since you're using GitHub, they may ask you to create a repository like: `amcp-ossrh-verification`
- Follow their specific instructions in the JIRA ticket

#### **1.4 Wait for Approval**
- Approval typically takes 1-2 business days
- You'll receive updates via JIRA ticket comments
- Once approved, you can proceed to the next steps

---

### **Step 2: GPG Key Setup**

#### **2.1 Generate GPG Key**
```bash
cd /home/kalxav/CascadeProjects
./setup-maven-central.sh  # This creates the setup files
./generate-gpg-key.sh     # Follow the instructions
```

#### **2.2 Edit GPG Configuration**
1. Edit the `gpg-key-config` file:
   ```bash
   nano gpg-key-config
   ```
2. Change the passphrase to something secure
3. Update the email if needed

#### **2.3 Generate the Key**
```bash
gpg --batch --generate-key gpg-key-config
```

#### **2.4 List and Export Key**
```bash
# List your keys
gpg --list-secret-keys --keyid-format LONG

# Export to key server (replace YOUR_KEY_ID with actual ID)
gpg --keyserver keyserver.ubuntu.com --send-keys YOUR_KEY_ID

# Also export to other key servers
gpg --keyserver keys.openpgp.org --send-keys YOUR_KEY_ID
gpg --keyserver pgp.mit.edu --send-keys YOUR_KEY_ID
```

---

### **Step 3: Maven Configuration**

#### **3.1 Configure Maven Settings**
```bash
# Copy template to settings.xml
cp ~/.m2/settings-central-template.xml ~/.m2/settings.xml

# Edit with your credentials
nano ~/.m2/settings.xml
```

#### **3.2 Update Settings with Your Information**
Replace the placeholders in `~/.m2/settings.xml`:
- `YOUR_SONATYPE_USERNAME`: Your Sonatype JIRA username
- `YOUR_SONATYPE_PASSWORD`: Your Sonatype JIRA password
- `YOUR_GPG_KEY_ID`: Your GPG key ID (from step 2.4)
- `YOUR_GPG_PASSPHRASE`: Your GPG key passphrase

Example:
```xml
<servers>
    <server>
        <id>ossrh</id>
        <username>john.doe</username>
        <password>your-jira-password</password>
    </server>
</servers>

<profiles>
    <profile>
        <id>ossrh</id>
        <properties>
            <gpg.executable>gpg</gpg.executable>
            <gpg.keyname>ABCD1234EFGH5678</gpg.keyname>
            <gpg.passphrase>your-gpg-passphrase</gpg.passphrase>
        </properties>
    </profile>
</profiles>
```

---

## 🚀 **Deployment Process**

### **Step 4: Deploy to Staging**

#### **4.1 Run Deployment Script**
```bash
cd /home/kalxav/CascadeProjects
./deploy-to-central.sh
```

This script will:
- Build the project with Maven Central POM
- Run tests
- Generate sources and javadoc JARs
- Sign all artifacts with GPG
- Deploy to Sonatype staging repository

#### **4.2 Expected Output**
```
✅ Prerequisites check passed
✅ Build successful
ℹ️  Deploying to Maven Central staging repository...
[INFO] Uploading to ossrh: https://s01.oss.sonatype.org/service/local/staging/deploy/maven2/org/amcp/amcp-core/1.5.0/amcp-core-1.5.0.pom
[INFO] Uploaded to ossrh: https://s01.oss.sonatype.org/service/local/staging/deploy/maven2/org/amcp/amcp-core/1.5.0/amcp-core-1.5.0.pom (4.2 kB at 2.1 kB/s)
...
✅ 🎉 Deployment to staging successful!
```

---

### **Step 5: Release from Staging**

#### **5.1 Access Sonatype Nexus**
1. Go to: https://s01.oss.sonatype.org/
2. Login with your Sonatype credentials
3. Click "Staging Repositories" in the left menu

#### **5.2 Find Your Repository**
1. Look for a repository named like: `orgamcp-XXXX` (where XXXX is a number)
2. It should contain your `org.amcp:amcp-core:1.5.0` artifacts
3. Select the repository

#### **5.3 Close the Repository**
1. Click "Close" button
2. Provide a description: "AMCP Core v1.5.0 release"
3. Click "Confirm"
4. Wait for validation to complete (usually 2-10 minutes)

#### **5.4 Release to Central**
1. Once validation passes, select the repository again
2. Click "Release" button
3. Provide a description: "Release AMCP Core v1.5.0 to Maven Central"
4. Check "Automatically Drop" (recommended)
5. Click "Confirm"

---

## ⏱️ **Timeline & Availability**

### **Immediate (0-30 minutes)**
- Artifacts available in Sonatype repository
- Can be used with Sonatype repository URL

### **2-4 Hours**
- Artifacts sync to Maven Central
- Available at: https://repo1.maven.org/maven2/org/amcp/amcp-core/1.5.0/

### **24 Hours**
- Fully propagated to all Maven mirrors worldwide
- Available via standard Maven/Gradle without special repository configuration

---

## 🔍 **Verification**

### **Check Deployment Status**
```bash
# Check if available on Maven Central
curl -I https://repo1.maven.org/maven2/org/amcp/amcp-core/1.5.0/amcp-core-1.5.0.jar

# Search Maven Central
curl "https://search.maven.org/solrsearch/select?q=g:org.amcp+AND+a:amcp-core&rows=20&wt=json"
```

### **Test Integration**
Create a test project with:
```xml
<dependency>
    <groupId>org.amcp</groupId>
    <artifactId>amcp-core</artifactId>
    <version>1.5.0</version>
</dependency>
```

---

## 📊 **Expected Results**

### **✅ Successful Deployment Indicators**
- Repository appears in Sonatype Nexus
- All artifacts (JAR, sources, javadoc, POM) are present
- All artifacts are properly signed (`.asc` files)
- Validation passes without errors
- Release completes successfully

### **🌐 Global Availability**
Once released, AMCP Core will be available:
- **Maven Central**: https://repo1.maven.org/maven2/org/amcp/amcp-core/1.5.0/
- **Maven Search**: https://search.maven.org/artifact/org.amcp/amcp-core/1.5.0/jar
- **MVN Repository**: https://mvnrepository.com/artifact/org.amcp/amcp-core/1.5.0

### **📈 Developer Impact**
- **Global Access**: Available to millions of Java developers
- **Easy Integration**: Standard Maven/Gradle dependency
- **Professional Distribution**: Trusted Maven Central infrastructure
- **Version Management**: Proper semantic versioning
- **Dependency Resolution**: Automatic transitive dependency handling

---

## 🚨 **Troubleshooting**

### **Common Issues**

#### **GPG Signing Errors**
```bash
# Test GPG signing
echo "test" | gpg --clearsign

# If errors, check:
gpg --list-secret-keys
export GPG_TTY=$(tty)
```

#### **Authentication Errors**
- Verify Sonatype credentials in `~/.m2/settings.xml`
- Ensure JIRA account is active
- Check if group ID is approved

#### **Validation Failures**
- Ensure all required artifacts are present (JAR, sources, javadoc, POM)
- Verify all artifacts are signed
- Check POM completeness (all required fields)

#### **Network Issues**
```bash
# Test connectivity
curl -I https://s01.oss.sonatype.org/

# Check proxy settings if behind corporate firewall
```

---

## 📋 **Checklist for Success**

### **Pre-Deployment**
- [ ] Sonatype account created and verified
- [ ] Group ID (org.amcp) approved via JIRA ticket
- [ ] GPG key generated and uploaded to key servers
- [ ] Maven settings.xml configured with credentials
- [ ] All tests pass locally

### **Deployment**
- [ ] Staging deployment successful
- [ ] All artifacts present in staging repository
- [ ] All artifacts properly signed
- [ ] Repository validation passes
- [ ] Repository successfully closed
- [ ] Repository successfully released

### **Post-Deployment**
- [ ] Artifacts available on Maven Central (2-4 hours)
- [ ] Maven search shows the artifact
- [ ] Test project can resolve dependency
- [ ] Documentation updated with Maven coordinates

---

## 🎉 **Success Metrics**

### **Technical Success**
- ✅ Artifacts deployed to Maven Central
- ✅ All required files present and signed
- ✅ Dependency resolution works globally
- ✅ Professional metadata and documentation

### **Business Impact**
- 🌍 **Global Reach**: Available to millions of Java developers
- 🚀 **Easy Adoption**: Standard dependency management
- 📈 **Professional Image**: Trusted distribution channel
- 🔄 **Ecosystem Growth**: Foundation for community contributions

---

## 🌟 **Final Result**

Once successfully deployed, AMCP Core v1.5.0 will be:

**🌐 Globally Available**
```xml
<dependency>
    <groupId>org.amcp</groupId>
    <artifactId>amcp-core</artifactId>
    <version>1.5.0</version>
</dependency>
```

**📊 Professionally Distributed**
- Maven Central: Trusted by enterprise developers
- Automatic mirrors: Fast downloads worldwide  
- Dependency resolution: Seamless integration
- Version management: Clear upgrade paths

**🚀 Ready for Enterprise**
- Production-ready distribution
- Professional metadata and documentation
- Signed artifacts for security
- Standard Java ecosystem integration

---

**🎯 Execute the setup and deployment process to make AMCP Core v1.5.0 available to the global Java developer community via Maven Central!**
