```bash
#!/bin/bash
# Automated Jenkins Plugin Installer

JENKINS_URL="http://localhost:8080"
JENKINS_USER="admin"
JENKINS_CLI_JAR="/tmp/jenkins-cli.jar"

#Prompt for API token at runtime - never stored in the script or elsewhere and won't show on screen thanks to the -s flag (s for silent)
read -s -p "Enter your Jenkins API token: " JENKINS_TOKEN
echo ""

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
