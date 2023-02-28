# FROM jenkins/jenkins:latest

# #log in as root user
# USER root

# #update and install requirements
# RUN apt update && apt-get install zip -y && apt-get install curl -y && apt-get install ca-certificates -y

# #install aws cli
# RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip
# RUN ./aws/install

# #install kubectl
# RUN curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
# RUN echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
# RUN apt-get update
# RUN apt-get install -y kubectl

# #install eksctl
# RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
# RUN mv /tmp/eksctl /usr/local/bin

# #install docker cli
# RUN curl -sSL https://get.docker.com/ | sh

# RUN 

# # set user Jenkins
# USER jenkins
