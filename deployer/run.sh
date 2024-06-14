#!/bin/bash

GIT_REPOPOSITORY_URL=`cat /run/secrets/git/url`

git clone ${GIT_REPOPOSITORY_URL} .

/maven/mvnw package

source target/maven-archiver/pom.properties

ARTIFACT_REPOSITORY_ID=`cat /run/secrets/artifactory/maven/id`
ARTIFACT_REPOSITORY_URL=`cat /run/secrets/artifactory/maven/url`

/maven/mvnw deploy:deploy-file \
    -Dfile=target/${artifactId}-${version}.jar \
    -DpomFile=pom.xml \
    -DrepositoryId=${ARTIFACT_REPOSITORY_ID} \
    -Durl=${ARTIFACT_REPOSITORY_URL} \
    -DgroupId=${groupId} \
    -DartifactId=${artifactId} \
    -Dversion=${version}
