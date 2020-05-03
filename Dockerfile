FROM jenkins/jenkins


#####################
# SET ENV VARIALBES #
#####################
# ENV JMETER_PATH=~jmeter\
#    JMETER_VERSION=0.12.4

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

####################
# GET DEPENDENCIES #
####################

# Update the environment
USER root
RUN set -xe;
RUN apt-get update
RUN apt-get -y upgrade

# Install JDK. Required by jmeter
RUN cd /tmp

RUN wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz

RUN tar -zxvf jdk-8u*-linux-*.tar.gz
RUN mv jdk1.8.*/ /usr/
RUN update-alternatives --install /usr/bin/java java /usr/jdk1.8.*/bin/java 2
RUN update-alternatives --set java /usr/jdk1.8.0_131/bin/java

#Download jmeter
RUN cd /tmp
RUN wget --no-check-certificate --no-cookies https://downloads.apache.org/jmeter/binaries/apache-jmeter-5.2.1.tgz
RUN tar -zxvf apache-jmeter-5.2.1.tgz
RUN mv apache-jmeter-5.2.1 /var/
RUN chown -R jenkins:jenkins /var/apache-jmeter-5.2.1

#Install Nodejs
RUN apt-get update
RUN apt-get -y install curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_12.x  | bash -
RUN apt-get -y install nodejs
RUN npm install
RUN npm install -g newman

# make jenkins the owner of var
RUN chown -R jenkins /var/jenkins_home/

USER jenkins