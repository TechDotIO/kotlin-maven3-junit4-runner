FROM maven:3.5-jdk-8

LABEL maintainer <coders@tech.io>

## BUILD process

ARG USER_HOME_DIR="/root"
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

COPY settings.xml $USER_HOME_DIR/.m2/
COPY ./build.sh /project/build

## RUN process

# Install K2JVMCompiler
COPY docker/k2.tar.gz /opt/techio
RUN gunzip -c /opt/techio/k2.tar.gz | tar xvC /opt/techio \
  && rm /opt/techio/k2.tar.gz

COPY docker/kotlin-compiler-junit-runner.sh /opt/techio/junit-runner/
COPY maven3-junit4-runner/target/java-maven3-junit4-runner-0.0.1-SNAPSHOT-jar-with-dependencies.jar /opt/techio/junit-runner/junit-runner.jar

ENTRYPOINT ["/opt/techio/junit-runner/kotlin-compiler-junit-runner.sh"]
