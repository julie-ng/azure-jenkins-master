ARG JENKINS_VERSION=2.235.1

FROM jenkins/jenkins:${JENKINS_VERSION}
LABEL maintainer="Julie Ng <me@julie.io>"

ARG AZ_CLI_VERSION=2.7.0
ARG DEBIAN_FRONTEND=noninteractive

USER root

# Install Azure CLI per docs
# https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest

# install utils
RUN apt-get update && \
		apt-get -y install ca-certificates curl apt-transport-https apt-utils lsb-release gnupg

# add microsoft repo, install azure-cli
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
    	gpg --dearmor | \
    	tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null && \
		AZ_REPO="$(lsb_release -cs)" && \
		echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    	tee /etc/apt/sources.list.d/azure-cli.list && \
		apt-get update && \
		apt-get install -y azure-cli="${AZ_CLI_VERSION}-1~${AZ_REPO}" && \
		az --version

# Pre-install plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Pre-configure jenkins
COPY config/* /var/jenkins_configs/

# Disable startup Wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# Drop back to non-root
USER jenkins
