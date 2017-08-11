FROM techio/maven3-builder:1.4

ENV TECHIO_RUN_DIR /project/answer

# Install K2JVMCompiler
COPY docker/k2.tar.gz /usr/src/codingame
RUN gunzip -c /usr/src/codingame/k2.tar.gz | tar xvC /usr/src/codingame \
  && rm /usr/src/codingame/k2.tar.gz

COPY docker/kotlin-compiler-junit-runner.sh /usr/src/codingame/junit-runner/
COPY target/java-maven3-junit4-runner-0.0.1-SNAPSHOT-jar-with-dependencies.jar /usr/src/codingame/junit-runner/junit-runner.jar

ENTRYPOINT ["/usr/src/codingame/junit-runner/kotlin-compiler-junit-runner.sh"]
