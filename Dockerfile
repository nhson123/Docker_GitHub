
FROM ubuntu:16.04
LABEL "MAINTAINER" = " Michael Laccetti <michael@laccetti.com> <https://laccetti.com/)"

ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME       /usr/lib/jvm/java-8-oracle
ENV LANG            en_US.UTF-8
ENV LC_ALL          en_US.UTF-8

RUN apt-get update && \
  apt-get install -y --no-install-recommends locales && \
  locale-gen en_US.UTF-8 && \
  apt-get dist-upgrade -y && \
  apt-get --purge remove openjdk* && \
  echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
  echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" > /etc/apt/sources.list.d/webupd8team-java-trusty.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 && \
  apt-get update && \
  apt-get install -y --no-install-recommends oracle-java8-installer maven oracle-java8-set-default && \
  #apt-get install openjdk-8-jre\
apt-get clean all

# ADD a directory called docker-git-hello-world inside the UBUNTU IMAGE where you will be moving all of these files under this 
# DIRECTORY to
ADD . /usr/local/DockerGit

# AFTER YOU HAVE MOVED ALL THE FILES GO AHEAD CD into the directory and run mvn assembly.
# Maven assembly will package the project into a JAR FILE which can be executed
RUN cd  /usr/local/DockerGit && mvn assembly:assembly

#THE CMD COMMAND tells docker the command to run when the container is started up from the image. In this case we are
# executing the java program as is to print Hello World.
# CMD ["java", "-cp", "target\docker_git-1.0-SNAPSHOT-jar-with-dependencies.jar", "DockerGit"]
CMD ["java", "-jar",  "/usr/local/DockerGit/target/docker_git-1.0-SNAPSHOT-jar-with-dependencies.jar"]
#java -cp target\docker_git-1.0-SNAPSHOT-jar-with-dependencies.jar DockerGit
#CMD ["java", "-version"]
