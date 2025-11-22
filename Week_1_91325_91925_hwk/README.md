Week 1 EC2 Instance Creation

##### Remember this before we start...
- Uses virtualization to create smaller computers (that run on someone else's physical systems so you don't have to worry about that)
	- Provides vCPU (virtual CPU), memory (fast temp storage for computing, and [[block storage]] (EBS - hard drives and SSDs for longer-term storage that you rent out per your AWS terms)
- An [[EC2 instance]] is the specific virtual computer provisioned for us
- EC2 instances are ZONAL RESOURCES
	- You won't find them in us-east-1 (the #aws_regions ) but you can create them in us-east-1a (the #aws_availability_zones )

More on this from Amazon can be found at: 
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html

![[Pasted image 20251106231035.png]]

#### Creating an EC2
##### Step 1: Create security group
- AWS Console
	- Verify the region that you are using
- Click on EC2 Dashboard
- [[Security Group]] (whether creating #aws_security_group or selecting a previously made one, you need a SG)
	- Click "Create Security Group"
	- Enter SG name and description
	- Verify that the VPC is set to [[Default VPC]] (or the one that you want if you already have VPCs created)
	- Add inbound HTTP rule with "Anywhere IPV4" source (0.0.0.0)
	- Make sure that "all traffic" is allowed in outbound rules
		- Add outbound all traffic rule with "Anywhere IPV4" egress (0.0.0.0)
	- Ports
		- HTTP 80 Anywhere
		- SSH 22
- Verify that the SG is created and has the permissions that you would like it to have

##### Step 2: Get your startup script
- s/e . Just pick the appropriate script for what this EC2 will be needing

##### Step 3: Launch EC2 Instance
1. **Navigate to Instances:**
    - Left pane → Instances → Instances
    - Click "Launch Instances"
    
2. **Configure Instance:**
    - **Name and Tags:** Enter instance name, add relevant tags
    - **AMI Selection:** Review AMI menu, ensure defaults are selected, collapse
    - **Instance Type:** Review instance type menu, ensure proper sizing, collapse
    - **Key Pair:** Select "Proceed without key pair" (unless you already have one or would like to create one to make things more secure), collapse
 
3. **Network Settings:**
    - **Don't click "Edit"**
    - Verify VPC selection
    - Ensure "Auto-assign public IP" is enabled
    - **Select your created Security Group** _(NOT "launch-wizard"!)_
    - Collapse section

4. **Storage Configuration:**
    - Review Configure Storage menu
    - _Brief discussion: What is EBS?_
    - Collapse section

5. **Advanced Settings:**
    - Open Advanced Settings
    - **Focus on User Data section only** - ignore everything else for the simple form EC2
    - Paste your chosen startup script (or upload it if you have the .txt file saved)

6. **Launch:**
    - Review configuration
    - Click "Launch Instance"

##### Step 4: Once the above steps are done you need to Test Your Web Server

[](https://github.com/cautchybailly/Class7-notes/tree/main/091325#step-4-test-your-web-server)

1. Wait for the instance to pass status checks
2. Copy the instance's **public DNS address**
3. Open your web browser
4. Navigate to: `http://<public-DNS-address>`
    - **Important (for simple EC2 à la week 1):** Use `http://` prefix, not `https://`

##### Teardown
[](https://github.com/cautchybailly/Class7-notes/tree/main/091325#teardown)

1. **Terminate the EC2 Instance**
    - Navigate to EC2 → Instances
    - Select your instance
    - Instance State → Terminate Instance

2. **Delete Security Group unless you plan on using it again** _(Optional)_
    - Navigate to EC2 → Security Groups
    - Select your created security group
    - Actions → Delete Security Group
    - _Note: Can only delete after instance termination_