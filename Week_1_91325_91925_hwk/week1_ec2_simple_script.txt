#!/bin/bash

# Install and start web server
dnf update -y
dnf install -y httpd
systemctl start httpd
systemctl enable httpd

# Variable for the URL
BASE_URL="http://169.254.169.254/latest"

# Get token for metadata requests
TOKEN=$(curl -X PUT "$BASE_URL/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 3600" -s)

# Collect instance info and save to variables
LOCAL_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s "$BASE_URL/meta-data/local-ipv4")
AZ=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s "$BASE_URL/meta-data/placement/availability-zone")
HOST_NAME=$(hostname -f)

# Create simple webpage and save to /var/www/html/index.html
# EOF marks where the HTML starts and stops basically 
cat << EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>EC2 Instance Info</title>
</head>

<body>
    <h1>My EC2 Instance</h1>
    
    <img src="https://www.w3schools.com/images/w3schools_green.jpg" alt="Instance Image">
    
    <h2>Instance Details</h2>
    <p><strong>Hostname:</strong> ${HOST_NAME}</p>
    <p><strong>Private IP:</strong> ${LOCAL_IP}</p>
    <p><strong>Availability Zone:</strong> ${AZ}</p>
</body>
</html>
EOF