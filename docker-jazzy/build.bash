#!/usr/bin/env bash
# This script builds the docker image

user_id=$(id -u)
#
# Build with cuda nvidia (devel)
docker build --rm -t autoware-jazzy:2025.02 --build-arg user_id=$user_id --no-cache -f Dockerfile .
