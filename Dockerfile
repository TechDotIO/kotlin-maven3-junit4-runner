FROM maven:3.5-jdk-8

LABEL maintainer <coders@tech.io>

## RUN process

# Install K2JVMCompiler
ADD docker/k2.tar.gz /opt/techio/
#RUN gunzip -c /opt/techio/k2.tar.gz | tar xvC /opt/techio \
#  && rm /opt/techio/k2.tar.gz

COPY docker/kotlin-compiler-junit-runner.sh /opt/techio/junit-runner/
COPY maven3-junit4-runner/target/maven3-junit4-runner-0.0.1-SNAPSHOT-jar-with-dependencies.jar /opt/techio/junit-runner/junit-runner.jar

## BUILD process

ARG USER_HOME_DIR="/root"
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

COPY docker/settings.xml $USER_HOME_DIR/.m2/
COPY docker/build.sh /project/build


ENTRYPOINT ["/opt/techio/junit-runner/kotlin-compiler-junit-runner.sh"]
