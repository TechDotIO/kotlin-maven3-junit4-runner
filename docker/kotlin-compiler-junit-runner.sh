#!/bin/bash
compilationExitCode=0
executionExitCode=0

JARS_DIR="/project/target/jars"
WORKSPACE_DIR="/project/workspace"

cd ${TECHIO_RUN_DIR}

classpath=$(echo ${JARS_DIR}/*.jar | tr ' ' ':')

find * -name "*.kt" -print0 | xargs -0 /usr/src/codingame/k2/K2JVMCompiler org.jetbrains.kotlin.cli.jvm.K2JVMCompiler -no-stdlib -cp "$classpath" -d "${WORKSPACE_DIR}"
compilationExitCode=$?

if [ $compilationExitCode -eq 0 ]; then
	java -cp "${WORKSPACE_DIR}:$classpath:/usr/src/codingame/junit-runner/junit-runner.jar" com.codingame.codemachine.runner.junit.JUnitTestListRunner $*
else
	exit $compilationExitCode
fi
