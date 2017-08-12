#!/bin/bash
# Can be invoked as:
# 		xxx.sh SOURCE_DIR TestClass
# 		xxx.sh SOURCE_DIR TestClass#testMethod
# 		xxx.sh TestClass
# 		xxx.sh TestClass#testMethod

compilationExitCode=0
executionExitCode=0

JARS_DIR="/project/target/jars"
WORKSPACE_DIR="/project/workspace"

cd /project/target

classpath=$(echo ${JARS_DIR}/*.jar | tr ' ' ':')

SOURCE_DIR=$(pwd)

if [ "$#" == "2" ]; then
	SOURCE_DIR=$(pwd)/$1
	shift
fi

cd ${SOURCE_DIR} || echo "Could not find directory ${SOURCE_DIR}" && exit 1

find * -name "*.kt" -print0 | xargs -0 /opt/techio/k2/K2JVMCompiler org.jetbrains.kotlin.cli.jvm.K2JVMCompiler -no-stdlib -cp "$classpath" -d "${WORKSPACE_DIR}"
compilationExitCode=$?

if [ $compilationExitCode -eq 0 ]; then
	java -cp "${WORKSPACE_DIR}:$classpath:/opt/techio/junit-runner/junit-runner.jar" io.tech.runner.junit.JUnitTestListRunner $1
else
	exit $compilationExitCode
fi
