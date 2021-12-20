# FROM jenkins/jenkins:2.303.3-lts-jdk11

FROM jenkins/jenkins:2.319.1-lts-jdk11
USER root
RUN apt-get update -y 
RUN apt-get install -y wget 

RUN apt-get update -y \
    && apt-get install -y sudo \
    && rm -rf /var/lib/apt/lists/*
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN apt-get upgrade -y
# RUN apt-cache search wget | grep wget
# RUN apt-get install wget -y
# RUN yum install epel-release git maven wget initscripts net-tools unzip -y
WORKDIR /opt
#maven-3.8.4
RUN wget https://dlcdn.apache.org/maven/maven-3/3.8.4/binaries/apache-maven-3.8.4-bin.tar.gz --no-check-certificate
RUN tar -xvf apache-maven-3.8.4-bin.tar.gz; mv /opt/apache-maven-3.8.4 /opt/maven
RUN echo -e "export M2_HOME=/opt/maven\nexport MAVEN_HOME=/opt/maven\nexport PATH=${M2_HOME}/bin:${PATH} > /etc/profile.d/mvn.sh | source /etc/profile.d/mvn.sh"
#sonar-scaner
RUN wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.6.2.2472-linux.zip
RUN unzip sonar-scanner-cli-4.6.2.2472-linux.zip; mv /opt/sonar-scanner-4.6.2.2472-linux /opt/sonar_scanner
# #aws-cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip; /opt/aws/install
RUN chmod -R 755 /usr/local/aws-cli; ln -s /usr/local/bin/aws /usr/bin/aws
# #kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# WORKDIR /root
# RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
# RUN curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
# RUN echo "$(<kubectl.sha256) kubectl" | sha256sum --check
# RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl; chmod +x kubectl; mkdir -p ~/.local/bin/kubectl; kubectl version --client


##python

# # #Docker

# CMD [/usr/sbin/init] 


RUN curl -fsSL https://get.docker.com/ | sh
# RUN systemctl start docker
# RUN systemctl enable docker
RUN service docker start
#; /sbin/chkconfig docker on; usermod -aG docker jenkins
# #Start
# #CMD service docker start; while true ; do sleep 100; done;
# CMD ["/bin/bash"]                    
# CMD [/usr/sbin/init] 