# Class 7 | Week 27 | March 14 Lab
## Jenkins Server Rebuild with Java 21 + Automated Plugin Installation

![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=jenkins&logoColor=white)
![Java](https://img.shields.io/badge/Java_21-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)

---

## 1. Lab Overview

This lab focuses on rebuilding a Jenkins CI/CD server from scratch using **Java 21** (replacing the previous Java 17 installation), deployed either as an **AWS EC2 instance** or a **Docker container**. 

The **Be A Man Challenge** extends this by automating the installation of all required Jenkins plugins at build/startup time — ensuring the server is fully operational with zero manual plugin configuration the moment it comes online.

---

## 2. Requirements

| Tool               | Required  | Notes                                          |
|--------------------|-----------|------------------------------------------------|
| AWS Console        |    ✅    | For EC2 instance creation                       |
| AWS CLI            |    ✅    | For SSH access and instance management          |
| Docker             |    ✅    | For Docker image path (if chosen)               |
| Git                |    ✅    | Version control for scripts and Dockerfile      |
| Java 21 (OpenJDK)  |    ✅    | Jenkins runtime requirement                     |
| Jenkins            |    ✅    | Target application being deployed               |
| Bash/Shell         |    ✅    | Plugin installation scripting                   |
| Jenkins CLI        |    ✅    | Used for scripted plugin installation           |

---

## 3. Project/Folder Structure

```
class7-week27-jenkins-rebuild/
├── README.md
├── Dockerfile                    # (if Docker path)
├── scripts/
│   ├── user_data.sh        # Jenkins + Java 21 install script
│   └── install_plugins.sh        # Automated plugin installation script
├── plugins.txt                   # List of required plugins
└── screenshots/
    ├── [FILL IN].png
    └── [FILL IN].png
```

---

## 4. Steps to Complete the Lab

### Part 1 — Homework: Rebuild Jenkins with Java 21

#### Option A: EC2 Deployment

##### **Step 1 — Launch EC2 Instance**

From AWS Console:
- AMI: Amazon Linux 2021 Kernel-6.1 AMI
- Instance type: t2.medium (recommended minimum for Jenkins)
- Key pair: [FILL IN your key pair name]
- VPC : select your preferred non-default VPC
- Auto assign public IP : enable
- Security Group: Open port 8080 (Jenkins), 22 (SSH). For this I had a pre-existing security group that I used
- Storage : 1 x 20 GiB gp3 (recommended mininum EBS volume for Jenkins)
- Advanced Details > User data : insert user data script  *you can skip adding this into the user data but that means you need to run the user data script manually when you SSH into the instance after it has been created so that everything can be installed.

--User Data Script--
```bash
#!/bin/bash

# Update system
sudo dnf update -y

# Install Java 21 (Corretto)
sudo dnf install java-21-amazon-corretto -y

# Verify Java
java -version

# Install fontconfig (required by Jenkins)
sudo dnf install fontconfig -y

# Add Jenkins stable repo
sudo wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/redhat-stable/jenkins.repo

# Import Jenkins GPG key
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Upgrade packages
sudo dnf upgrade -y

# Install Jenkins
sudo dnf install jenkins -y

# Enable Jenkins at boot and start it
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Confirm it's running
sudo systemctl status jenkins

# Print initial admin password
echo "===== INITIAL ADMIN PASSWORD ====="
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Click 'Launch instance' once the user data has been copied and pasted correctly. **Take note of your public IPv4 address and the initial admin password**

![Description](screenshots/EC2%20running%20in%20AWS%20Console.png)

##### **Step 2 — Connect to Instance**
Navigate to the folder holding your SSH key in Git Bash then run (be sure to change fields to your actual key and actual EC2 public IP):

```bash
chmod 400 [YOUR-KEY].pem
ssh -i [YOUR-KEY].pem ec2-user@[YOUR-EC2-PUBLIC-IP]
```

![Description](screenshots/SSH%20into%20your%20EC2%20instance.png)

##### **Step 3 - Check on Jenkins status**

Run the following command:

```bash
sudo systemctl status jenkins
```

You should see it showing an 'Active : active (running)...' message

![Description](screenshots/Jenkins%20status%20check.png)

##### **Step 5 — Retrieve Initial Admin Password**
Run the following command and copy the output
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

##### **Step 6 — Access Jenkins UI**
In your browser window, go to:

``` text
http://[YOUR-EC2-PUBLIC-IP]:8080
```

Insert your initial admin password in the password field then hit Enter

##### **Step 7 — Finish Jenkins Admin Account Setup**
In your browser you will see the screen entitled Customize Jenkins. Click on the button to 'Install Suggested Plugins' then wait for the installs to finish. Once finished you will be taken to a page entitled 'Create First Admin User'. Fill in the required fields and be sure not to forget your admin password. Click 'Save and Continue' once done. Click 'Save and Continue' on the 'Instance Configuration page as well. Your Jenkins setup is complete. Click 'Start Using Jenkins'

##### **Step 8 - Install Required Plugins**
Go to Manage Jenkins > Nodes > Built-in Node. 

![description](screenshots/Manage%20nodes.png)

There you will see that you don't have much space to actually use Jenkins. We need to fix this. In your CLI, run the following commands:

```bash
df -h /tmp
mount | grep /tmp
sudo mount -o remount,size=4G /tmp
sudo systemctl restart jenkins
```

Sign back into Jenkins in your browser and head back to Built-in Node. You should now see the 4gtemp space there.

##### **Step 10 — Install All Required Plugins**
Go to Manage Jenkins > Plugins > Available plugins. From there make sure to install the required plugins from the plugins.txt file

```text
aws credentials
pipeline aws
terraform
snyk security
pipeline GCP steps
google oauth-plugin
github integration
github oauth
pipeline github
```

---

#### Option B: Docker Deployment

**Step 1 — Build the Dockerfile**
In your directory of choice, build the Dockerfile. Your Dockerfile will look like this.

```dockerfile
FROM jenkins/jenkins:lts-jdk21

USER root

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    wget \
    && rm -rf /var/lib/apt/lists/*


# Copy plugins list
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

# Install plugins at build time

RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

USER jenkins
```

**Step 2 — Build and Run**
While still in the same directory, open up the CLI 

```bash
docker build -t jenkins-java21 .
docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  jenkins-java21
```

**Step 3 — Get Initial Admin Password**
```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

---

### Part 2 — Be A Man Challenge: Automated Plugin Installation

**plugins.txt**
```
aws-credentials
pipeline-aws
terraform
snyk-security
pipeline-googlecloudplatform
google-oauth-plugin
github-integration
github-oauth
pipeline-github
```

**install_plugins.sh** (for EC2 path)
```bash
#!/bin/bash
# Automated Jenkins Plugin Installer
# Summit Government Solutions / TheoU Class 7 Week 27

JENKINS_URL="http://localhost:8080"
JENKINS_USER="admin"
JENKINS_PASSWORD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
JENKINS_CLI_JAR="/tmp/jenkins-cli.jar"

echo "[+] Downloading Jenkins CLI..."
wget -q "$JENKINS_URL/jnlpJars/jenkins-cli.jar" -O $JENKINS_CLI_JAR

echo "[+] Installing plugins..."
PLUGINS=(
  "aws-credentials"
  "pipeline-aws"
  "terraform"
  "snyk-security"
  "pipeline-googlecloudplatform"
  "google-oauth-plugin"
  "github-integration"
  "github-oauth"
  "pipeline-github"
)

for plugin in "${PLUGINS[@]}"; do
  echo "  Installing: $plugin"
  java -jar $JENKINS_CLI_JAR \
    -s $JENKINS_URL \
    -auth $JENKINS_USER:$JENKINS_PASSWORD \
    install-plugin $plugin
done

echo "[+] Restarting Jenkins to apply plugins..."
sudo systemctl restart jenkins

echo "[✓] All plugins installed and Jenkins restarted."
```

**Run the script:**
```bash
chmod +x scripts/install_plugins.sh
./scripts/install_plugins.sh
```

**Verify plugins installed:**
```bash
java -jar /tmp/jenkins-cli.jar \
  -s http://localhost:8080 \
  -auth admin:[PASSWORD] \
  list-plugins | grep -E "aws-credentials|pipeline-aws|terraform|snyk"
```

---

## 7. Artifacts / Screenshots

> "SHOW YOUR WORK" ~ Kevin Samuels

- [ ] Screenshot: EC2 instance running in AWS Console
- [ ] Screenshot: SSH connection established
- [ ] Screenshot: `systemctl status jenkins` showing active/running
- [ ] Screenshot: Jenkins UI accessible at port 8080
- [ ] Screenshot: Plugin installation script running in terminal
- [ ] Screenshot: Jenkins Plugin Manager showing all 9 plugins installed
- [ ] Screenshot: Jenkins dashboard fully operational

`[FILL IN — paste your screenshots here]`

---

## 8. Teardown / Destroy Infrastructure

### EC2 Path
```bash
# Stop Jenkins service
sudo systemctl stop jenkins

# Terminate EC2 instance (from AWS Console or CLI)
aws ec2 terminate-instances --instance-ids [YOUR-INSTANCE-ID]

# Verify termination
aws ec2 describe-instances --instance-ids [YOUR-INSTANCE-ID] \
  --query 'Reservations[].Instances[].State.Name'
```

### Docker Path
```bash
# Stop and remove container
docker stop jenkins
docker rm jenkins

# Remove image
docker rmi jenkins-java21

# Remove volume (if done with data)
docker volume rm jenkins_home
```

---

## 9. Lessons Learned

### a. What is relatable to the user/customer?
[FILL IN — e.g., "Automating plugin installation means any new Jenkins server spun up in our org is immediately production-ready, saving engineering time and reducing human error during onboarding."]

### b. What struggles did you have?
[FILL IN — e.g., Java version conflicts, plugin dependency errors, Jenkins not starting after install, security group misconfiguration, etc.]

### c. How did you save money after teardown? Any challenges?
[FILL IN — e.g., "Terminated the EC2 instance immediately after lab completion. Using t2.medium instead of a larger instance kept costs under $0.05 for the lab duration. Docker path has zero AWS cost."]

---

## 10. References

### a. Official Documentation
- [Jenkins Installation on Ubuntu](https://www.jenkins.io/doc/book/installing/linux/)
- [Jenkins Docker Official Image](https://hub.docker.com/r/jenkins/jenkins)
- [jenkins-plugin-cli Docs](https://github.com/jenkinsci/plugin-installation-manager-tool)
- [OpenJDK 21](https://openjdk.org/projects/jdk/21/)
- [AWS EC2 User Guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/)

### b. Books
[FILL IN — APA 7.0 format if applicable]

### c. Video / Article References
[FILL IN — TheoU videos, YouTube, Medium articles referenced]

### d. Repositories
[FILL IN — GitHub/GitLab links]

---

## 11. Troubleshooting

### Common Issues

**Jenkins won't start after install**
```bash
sudo systemctl status jenkins
sudo journalctl -u jenkins -n 50
```

**Wrong Java version being used**
```bash
sudo update-alternatives --config java
# Select Java 21 from the list
java -version
```

**Plugin install fails — authentication error**
```bash
# Confirm password is correct
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# Test CLI connection
java -jar /tmp/jenkins-cli.jar -s http://localhost:8080 \
  -auth admin:[PASSWORD] who-am-i
```

**Port 8080 not accessible**
```bash
# Check Jenkins is listening
sudo ss -tlnp | grep 8080

# Check security group in AWS Console — inbound rule for port 8080 required
```

**Docker container exits immediately**
```bash
docker logs jenkins
# Check for Java/permission errors in output
```

**Plugin already installed warning**
```bash
# Safe to ignore — jenkins-plugin-cli skips already-installed plugins
```

[FILL IN — any additional errors or issues you encountered]

---

## 12. Author & Contributors

| Role         | Name                                       |
|------        |------                                      |
| Author       | Cautchy Bailly                             |
| Group Leader | Jacques Payne                              |
| Contributors | TheoWAF, Aaron McDonald, Inconformista Rob |
| Group Name   | TKO                                        |

**Course:** TheoU DevOps Bootcamp Class 7 
**Class:** Class 7 | Week 27  
**Lab Date:** March 14, 2026  
**Version:** 1.0  
**Last Updated:** [FILL IN]
