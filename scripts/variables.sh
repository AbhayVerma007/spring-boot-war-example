#!/bin/bash

# --- Color Codes for Jenkins/Terminal Output ---
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export MAGENTA='\033[0;35m'
export CYAN='\033[0;36m'
export BOLD='\033[1m'
export NOCOLOR='\033[0m'

# --- Project Paths & Context ---
# This ensures your scripts know exactly where to deploy
export TOMCAT_VERSION="10"
export TOMCAT_HOME="/var/lib/tomcat10"
export WAR_NAME="hello-world-0.0.1-SNAPSHOT.war"

# --- Infrastructure Details ---
# Useful for logging which environment the script is hitting
export JAVA_HOME_DEFAULT="/usr/lib/jvm/java-21-openjdk-amd64"
export HOSTNAME=$(hostname)
export IP_ADDR=$(hostname -I | awk '{print $1}')

# --- Feedback Messages ---
export MSG_START="${CYAN}>>> Starting Execution on ${HOSTNAME} (${IP_ADDR})${NOCOLOR}"
export MSG_SUCCESS="${GREEN}>>> Operation Completed Successfully!${NOCOLOR}"
export MSG_FAIL="${RED}>>> Critical Error Detected. Check logs.${NOCOLOR}"
