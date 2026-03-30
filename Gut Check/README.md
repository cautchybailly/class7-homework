# Class 7 | Gut Check Lab
## Jenkins Pipeline + Terraform S3 Deployment + Armageddon Clearance

![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=jenkins&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS S3](https://img.shields.io/badge/AWS_S3-FF9900?style=for-the-badge&logo=amazons3&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)
![Webhooks](https://img.shields.io/badge/Webhooks-005571?style=for-the-badge&logo=webhooks&logoColor=white)

---

## 1. Lab Overview

This Gut Check lab validates mastery of the core Class 7 DevOps principles up until this point by combining
Jenkins CI/CD, Terraform infrastructure-as-code, AWS S3, and GitHub webhooks into a single end-to-end workflow.

The objective is to demonstrate:
- A successful Jenkins pipeline run (triggered via GitHub webhook)
- Webhook invocation proof (empty or otherwise)
- Terraform-provisioned S3 bucket deployed to AWS
- Screenshot/image artifacts uploaded to the S3 bucket as Armageddon clearance proof
- All code and configuration pushed to a GitHub repository
- A reference file linking to the group Armageddon repo

**Armageddon Repo:**
https://github.com/jdpayne68/class-7-armageddon-tko-group/tree/main

---

## 2. Requirements

| Tool        | Required | Notes                                            |
|----------   |----------|------------------------------------------------  |
| Jenkins     | YES      | CI/CD pipeline execution                         |
| Terraform   | YES      | S3 bucket provisioning                           |
| AWS Console | YES      | Verify S3 bucket and uploaded objects            |
| AWS CLI     | YES      | Credential configuration for Terraform + Jenkins |
| Git         | YES      | Version control, push to GitHub                  |
| GitHub      | YES      | Remote repo + webhook configuration              |


---

## 3. Project/Folder Structure

```
class7-gut-check/
├── README.md
├── TKO-armageddon-link.md (Link to the Armageddon repo)
├── Jenkinsfile 
├── Terraform/
│ ├── main.tf # S3 bucket resource definition
│ ├── variables.tf # Input variables
│ ├── outputs.tf # Output values (bucket name, ARN)
│ └── provider.tf # AWS provider configuration
├── Lab Confirmation Screenshots
| ├── gut-check-webhooks.png
| ├── Jenkins-5-stages-green.png
| ├── outputs.png
| ├── s3-bucket-created-with-placeholder.png
| ├── terraform-initi-successful.png
| ├── terraform-plan.png
├── Screenshots/
| └── theo-armageddon-approval.png
```

---

## 4. Steps to Complete the Lab

-------------------------------------------
PART 1 — Terraform: Provision the S3 Bucket
-------------------------------------------
Please see the individual Terraform files for the code. Effectively, the code is performing the following:

**provider.tf** |
This is telling Terraform that we are working with AWS and specifically using version 5.x of the AWS toolkit. It is also letting Terraform know to deploy everything in the region that we specify.

**variables.tf** |
This is our settings panel. To avoid hardcoding things, we define them once here and then reference them anywhere else that they are needed in the Terraform code. It makes things easier to make changes in one place instead of ten different places anytime a setting needs to be changed.

**main.tf** |
This is the "what are we actually building" portion of the code. Specifically, we are building an S3 bucker with the given name and labeling it so that we don't forget what it is for. We also go ahead and make sure that all files uploaded in the S3 bucket have us (the AWS account owner) as the owner of the files (prevents permission headaches). And finally, in this section we let it be knowns 

**outputs.tf** |
This portion is the "Tell me what got created" portion. Since we want to know the ID and ARN of the bucket that was created, we configure this output file to query and provide these pieces of information after everything has been successfully created. This information will be referenced with other AWS services if we were to continue onwards and need this bucker and can be used to let Jenkins know which specific bucket it needs to interact with.

**Run Terraform:** |
In order to run everything that we have build, you will head into the appropriate folder with the files and run the Terrafom IvPAD. The commands needed look like this:

```bash
cd terraform/

# Initialize Terraform (downloads AWS provider)
terraform init

# Make sure that the Terraform code chosen is valid
terraform validate

# Preview what will be created
terraform plan

# Deploy the S3 bucket
terraform apply -auto-approve

# Confirm output
terraform output
```

-------------------------------------------
PART 2 — Jenkins Pipeline Setup 
-------------------------------------------

**Jenkinsfile**
Our Jenkinsfile is stating that this is a pipeline and we can run it on any Jenkins server that is available. Before running anything, we set the environment variable so every stage knows which AWS region to use. Then we build on everything in order (stage by stage of course).

Stage 1: grab the code from Github
Stage 2: initialize Terraform using your AWS credentials that you created and stored for Jenkins
Stage 3: preview what Terraform is going to build. "Get the invoice before confirming that you are buying it" type of energy
Stage 4: actually build the S3 bucket
Stage 5: print confirmation of the build log as proof of completion


-------------------------------------------
PART 3 — GitHub Webhook Setup
-------------------------------------------

**Step 1 — Create your GitHub repo and push all files**
```bash
git init
git add .
git commit -m "Class 7 Gut Check — initial commit"
git branch -M main
git remote add origin https://github.com/cautchybailly/gutcheck.git
git push -u origin main
```

**Step 2 — Configure Webhook in GitHub**
- Go to your repo → **Settings → Webhooks → Add webhook**
- Payload URL: `http://54.221.83.237:8080/github-webhook/`
- Content type: `application/json`
- Events: **Just the push event** (or All events if you want)
- Click **Add webhook**

**Step 3 — Configure Jenkins job to trigger on webhook**
- Jenkins → Your Pipeline Job → **Configure**
- Under **Build Triggers** → check **GitHub hook trigger for GITScm polling**
- Save

**Step 4 — Test the webhook**
```bash
# Make a small change and push to trigger it
echo "# webhook test" >> README.md
git add README.md
git commit -m "test: trigger webhook"
git push
```

-------------------------------------------
PART 4 — Armageddon Reference File
-------------------------------------------

**armageddon-link.md**
See the file itself for exact details. Push this file to your repo along with everything else.

---

## 7. Artifacts / Screenshots

> "SHOW YOUR WORK" ~ Kevin Samuels

- [ ] Screenshot: Terraform `init` output
- [ ] Screenshot: Terraform `plan` output
- [ ] Screenshot: Terraform `apply` — resources created
- [ ] Screenshot: S3 bucket visible in AWS Console
- [ ] Screenshot: Screenshots/artifacts uploaded inside the S3 bucket
- [ ] Screenshot: Jenkins pipeline — all stages green
- [ ] Screenshot: GitHub webhook delivery confirmation (green checkmark)
- [ ] Screenshot: GitHub repo showing all files pushed
- [ ] Screenshot: Armageddon repo link file in repo

---

## 8. Teardown / Destroy Infrastructure (Optional)

```bash
# Destroy the S3 bucket and all contents via Terraform
cd Terraform/
terraform destroy -auto-approve

# Verify bucket is gone in AWS Console or via CLI
aws s3 ls | grep [YOUR-BUCKET-NAME]

# Stop Jenkins if running on EC2 (to avoid ongoing charges)
sudo systemctl stop jenkins

# Optionally terminate the EC2 instance from AWS Console
aws ec2 terminate-instances --instance-ids [YOUR-INSTANCE-ID]
```

> **Important:** S3 buckets with objects must be emptied before Terraform can destroy
> them unless `force_destroy = true` is set in `main.tf`. Add this to avoid errors:
> ```hcl
> resource "aws_s3_bucket" "gut_check_bucket" {
> bucket = var.bucket_name
> force_destroy = true
> }
> ```

---

## 9. Lessons Learned

### a. What is relatable to the user/customer?
End-to-end automation means infrastructure is created, artifacts are stored, and pipelines run without manual intervention — exactly how production
DevOps teams operate. Despite the errors that made have needed to be resolved in setting it up the first time, every time that the successful automation is run from there on will be without manual intervention. 

### b. What struggles did you have?
Webhook not triggering, AWS credential configuration in Jenkins, Terraform state issues, S3 bucket naming conflicts (must be globally unique), etc.

### c. How did you save money after teardown? Any challenges?
Ran `terraform destroy` immediately after lab completion.
S3 storage costs are minimal but terminating the EC2 Jenkins server eliminates the largest cost since any update to the GitHub will trigger the webhook and potentially store more and more in the S3 bucket.

---

## 10. References

### a. Official Documentation
- [Terraform AWS S3 Bucket Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
- [Jenkins GitHub Integration Plugin](https://plugins.jenkins.io/github/)
- [GitHub Webhooks Documentation](https://docs.github.com/en/webhooks)
- [AWS S3 Documentation](https://docs.aws.amazon.com/s3/)
- [Jenkinsfile Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)

### b. Books
N/A

### c. Video / Article References
Learn Jenkins! Complete Jenkins Course - Zero to Hero : (https://www.youtube.com/watch?v=6YZvp2GwT0A)


### d. Repositories
- Armageddon Repo: https://github.com/jdpayne68/class-7-armageddon-tko-group/tree/main
- Your Lab Repo: https://github.com/cautchybailly/class7-homework/tree/main/Gut%20Check

---

## 11. Troubleshooting

**Terraform: S3 bucket already exists error**
```bash
# Bucket names must be globally unique across all AWS accounts
# Change var.bucket_name to something more unique
# e.g., "gut-check-[your-initials]-[date]"
```

**Terraform: bucket not empty on destroy**
```bash
# Add force_destroy = true to your S3 bucket resource in main.tf
# OR empty the bucket manually first:
aws s3 rm s3://[YOUR-BUCKET-NAME] --recursive
terraform destroy -auto-approve
```

**Jenkins pipeline: AWS credentials not found**
```bash
# Verify AWS credentials are configured in Jenkins:
# Manage Jenkins → Credentials → Add Credentials
# Kind: AWS Credentials
# ID must match what's in your Jenkinsfile: 'aws-credentials'
```

**Webhook not triggering Jenkins build**
```bash
# Check webhook delivery in GitHub:
# Repo → Settings → Webhooks → click your webhook → Recent Deliveries
# Look for red X vs green checkmark

# Verify Jenkins URL is publicly accessible (not localhost)
# Verify port 8080 is open in EC2 Security Group
# Verify GitHub plugin is installed in Jenkins
```

**Terraform init fails**
```bash
# Check internet connectivity from your machine/EC2
curl https://registry.terraform.io

# Verify Terraform is installed
terraform version

# Re-initialize with upgrade flag
terraform init -upgrade
```

---

## 12. Author & Contributors

| Role | Name |
|--------------|-----------------|
| Author | Cautchy Bailly |
| Group Leader | Jacques Payne |
| Group Name | TKO (Tetsuzai Kube Ouroboros)|

**Course:** TheoU DevOps Bootcamp
**Class:** Class 7 | Gut Check Lab
**Lab Date:** March 29, 2026
**Version:** 1.0
#trigger build
