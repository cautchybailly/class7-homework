```dockerfile
FROM jenkins/jenkins:lts-jdk21

#switch to root user to install packages and plugins
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

#switch back to jenkins user after installing packages and plugins since jenkins runs as a non-root user for security reasons
USER jenkins
```