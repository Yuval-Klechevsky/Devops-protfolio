FROM jenkins/jenkins:lts

USER root

RUN apt-get update -y && \
    apt-get install docker.io -y && \
    apt install docker-compose -y


RUN usermod -aG docker jenkins

RUN apt-get install awscli -y

USER jenkins 