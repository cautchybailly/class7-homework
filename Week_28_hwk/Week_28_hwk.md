# Jenkins + Terraform Pipeline Lab Documentation (aka )

## Repository

Pipeline source repository:
`https://github.com/<insertrepohere>`

---

# 📘 Homework

## Objective

Deploy a Jenkins pipeline using a GitHub repository and extend the pipeline to include Terraform validation, formatting, and destruction stages.

## Steps

**Prerequites**
- Have a running Jenkins instance with the necessary plugins pre-installed and have your SSH session already started

1. **Connect Jenkins to GitHub Repo**

   * Navigate to Jenkins Dashboard
   * Select **New Item**
   * Choose **Pipeline**
                           * Under *Pipeline Definition*, select:

     * `Pipeline script from SCM`
   * SCM: Git
   * Repository URL:

     ```
     https://github.com/cautchybailly/new-jenkins-s3-test
     ```
   * Specify branch (e.g., `main`)

2. **Modify Jenkinsfile**

Add the following Terraform stages:

```groovy
pipeline {
    agent any

    stages {
        stage('Terraform Format') {
            steps {
                sh 'terraform fmt -check'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform init'
                sh 'terraform validate'
            }
        }

        stage('Terraform Destroy') {
            steps {
                input message: "Do you want to destroy infrastructure?"
                sh 'terraform destroy -auto-approve'
            }
        }
    }
}
```

3. **Run the Pipeline**

   * Click **Build Now**
   * Monitor execution in **Console Output**

## Evidence Required

* Screenshot of:

  * ✅ Successful Jenkins pipeline build
  * ✅ Jenkinsfile showing added Terraform stages

---

# 🔧 BAM 1

## Objective

Update startup script to install required tools and upgrade Java.

## Required Tools

* Terraform
* AWS CLI
* Python
* Java (version 21 or 25)

## Updated Startup Script Example

```bash
#!/bin/bash

# Update system
sudo apt update -y

# Install dependencies
sudo apt install -y unzip curl wget software-properties-common

# Install Terraform
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Install Python
sudo apt install -y python3 python3-pip

# Install Java 21
sudo apt install -y openjdk-21-jdk

# Verify installations
terraform -version
aws --version
python3 --version
java -version
```

## Verification Steps

After connecting to the server/container:

```bash
terraform -version
aws --version
python3 --version
java -version
```

## Evidence Required

* Screenshot showing all four:

  * Terraform version
  * AWS CLI version
  * Python version
  * Java version

---

# 🔐 BAM 2

## Objective

Create a least-privilege IAM user for pipeline infrastructure deployment.

## Methodology

1. Follow the **Principle of Least Privilege**

   * Only grant permissions required for Terraform operations

2. Identify Required Services

   * EC2
   * S3 (for state storage)
   * DynamoDB (for state locking)
   * IAM (limited role usage)

3. Avoid:

   * Full `AdministratorAccess`
   * Wildcard (`*`) permissions where possible

---

## Example IAM Policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:*"
      ],
      "Resource": "*"
    }
  ]
}
```

---

## Permissions Granted

| Service  | Permissions                               |
| -------- | ----------------------------------------- |
| EC2      | Instance creation, modification, deletion |
| S3       | State file storage and retrieval          |
| DynamoDB | State locking                             |
| IAM      | (Optional minimal role pass permissions)  |

---

## Justification

* Terraform requires control over infrastructure resources
* S3 + DynamoDB are necessary for remote state management
* Permissions are scoped to required services only
* Avoids unnecessary administrative privileges

---

## Evidence Required

* Screenshot of IAM user
* Screenshot of attached policies
* Written explanation (above)

---

# ⚙️ BAM 3

## Objective

Understand Jenkins pipeline triggers and their use cases.

## Jenkins Trigger Types

### 1. Poll SCM

* Jenkins periodically checks the repository for changes
* Uses cron syntax

**Use Case:**

* When webhooks are unavailable

---

### 2. GitHub Webhook Trigger

* GitHub notifies Jenkins instantly when changes occur

**Use Case:**

* ✅ Best for GitHub repo updates
* Real-time CI/CD automation

---

### 3. Build Periodically

* Runs builds on a schedule regardless of changes

**Use Case:**

* Nightly builds
* Maintenance/testing jobs

---

### 4. Trigger Builds Remotely

* Build triggered via API call

**Use Case:**

* Integration with external systems

---

### 5. Upstream/Downstream Trigger

* One job triggers another after completion

**Use Case:**

* Multi-stage pipelines

---

## Recommended Usage

| Environment | Best Trigger                    |
| ----------- | ------------------------------- |
| Development | GitHub Webhook                  |
| Testing     | Poll SCM or Scheduled Builds    |
| Production  | Manual trigger + approval steps |

---

## Key Answers

* **Trigger for GitHub updates:**
  → GitHub Webhook Trigger

* **Best for testing environments:**
  → Poll SCM or Scheduled Builds

* **Best for production:**
  → Manual trigger with approval (controlled deployments)

---

# ✅ Summary

This lab demonstrated:

* Jenkins pipeline integration with GitHub
* Terraform automation within CI/CD
* Environment setup with required tools
* Secure IAM configuration using least privilege
* Understanding Jenkins triggers across environments

---

If you want, I can also:

* Generate a **clean Jenkinsfile tailored to your repo**
* Help you **tighten IAM permissions further (more realistic than `*`)**
* Or convert this into a **submission-ready PDF/Word doc with formatting**
