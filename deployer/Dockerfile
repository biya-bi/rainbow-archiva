# syntax=docker/dockerfile:1

FROM eclipse-temurin:17-jdk-jammy AS base

RUN apt-get update \
  && apt-get -y install git \
  && apt-get clean

WORKDIR /git_repo

COPY .mvn/ /maven/.mvn
COPY mvnw /maven/

COPY ./run.sh /scripts/
RUN chmod +x /scripts/run.sh

ENTRYPOINT /scripts/run.sh
