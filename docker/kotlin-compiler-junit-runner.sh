#!/bin/bash
echo "TECHIO> terminal"
# Can be invoked as:
# 		xxx.sh SOURCE_DIR TestClass
# 		xxx.sh SOURCE_DIR TestClass#testMethod
# 		xxx.sh TestClass
# 		xxx.sh TestClass#testMethod

compilationExitCode=0
executionExitCode=0

BUILD_DIR="/build/libs"
WORKSPACE_DIR="/build/workspace"

mkdir -p "${WORKSPACE_DIR}"

SOURCE_DIR=$(pwd)
JARS_DIR=${BUILD_DIR}

if [ "$#" == "2" ]; then
	SOURCE_DIR=$(pwd)/$1
	JARS_DIR=${BUILD_DIR}/$1
	shift
fi

cd "${SOURCE_DIR}" || { echo "Could not find directory ${SOURCE_DIR}";exit 1; }

find * -name "*.kt" -print0 | xargs -0 /opt/techio/k2/K2JVMCompiler org.jetbrains.kotlin.cli.jvm.K2JVMCompiler -no-stdlib -jdk-home /docker-java-home -cp "$classpath" -d "${WORKSPACE_DIR}"
compilationExitCode=$?

classpath=$(echo ${JARS_DIR}/*.jar | tr ' ' ':')

if [ $compilationExitCode -eq 0 ]; then
	java -cp "${WORKSPACE_DIR}:$classpath:/opt/techio/junit-runner/junit-runner.jar" io.tech.runner.junit.JUnitTestListRunner $1
else
	exit $compilationExitCode
fi
sleep 1000
