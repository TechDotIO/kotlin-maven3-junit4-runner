#!/bin/bash

# Exit as soon as a command return status != 0
set -e

SRC_DIR=/project/target

TARGET_DIR=/build/libs
mkdir -p "${TARGET_DIR}"

M2_REP_DIR=/build/.m2/repository
mkdir -p "${M2_REP_DIR}"

cd "${SRC_DIR}"

find ${SRC_DIR} -name pom.xml -print0 | 
    while IFS= read -r -d $'\0' line; do 
        current_src_dir=$(dirname "${line}")
        sub_dir=${current_src_dir#${SRC_DIR}}
        current_target_dir=${TARGET_DIR}/${sub_dir}
        mkdir -p "${current_target_dir}"
        cd "${current_src_dir}"
        # Build the project: create all the jar files
        mvn -Dmaven.artifact.threads=10 clean install jar:test-jar -DskipTests dependency:build-classpath -Dmdep.outputFile="${current_target_dir}/classpath"
        # Copy the jar files into the target directory
        find "${current_src_dir}" -name "*.jar" -print0 |
        while IFS= read -r -d $'\0' jar_file; do
            cp "${jar_file}" "${current_target_dir}"
            done
        # Build classpath
#        mvn -Dmaven.artifact.threads=10 dependency:build-classpath -Dmdep.outputFile="${current_target_dir}/classpath"
        # Trick to prevent read from exiting with status code 1
        cat >> "${current_target_dir}/classpath" << EOF

EOF
        # Hard link dependencies
        IFS=':' read -ra jar_files < "${current_target_dir}/classpath"
        for jar_file in "${jar_files[@]}"; do
            ln "${jar_file}" "${current_target_dir}"
        done
    done

# Clean source directory
find "${SRC_DIR}" -mindepth 1 -delete

# Clean .m2 directory
rm -rf "${M2_REP_DIR}"
