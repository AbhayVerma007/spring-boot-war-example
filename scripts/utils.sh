#!/bin/bash

# Include variables for colors (RED, GREEN, NOCOLOR, etc.)
. ./scripts/variables.sh

# Prints error message to stderr and exits
# Args: 1=exit code, 2=message
function print_exit(){
    local error_code=${1}
    local error_msg=${2}
    echo -e "${RED}[Fail] ${error_msg}${NOCOLOR}" 1>&2
    exit ${error_code}
}

# Displays the content of a banner file
function showBanner(){
    local banner_file=${1}
    if [[ -f "$banner_file" ]]; then
        cat "${banner_file}"
    else
        echo -e "${YELLOW}Banner file not found.${NOCOLOR}"
    fi
}

# Visual spinner for long-running background processes
function showProgress(){
    local last_command_pid=${1}
    while kill -0 "${last_command_pid}" 2>/dev/null
    do 
        for i in '-' '\' '|' '/'
        do
            echo -ne "\b${i}"
            sleep 0.15
        done
        echo -en "\b"
    done
}

# Installs a system package via apt
function installPackage() {
    local packageName=${1}
    echo -e "${CYAN}Installing ${packageName}...${NOCOLOR}"
    
    # -qq for quiet mode, DEBIAN_FRONTEND ensures no prompts interrupt Jenkins
    DEBIAN_FRONTEND=noninteractive apt-get install -y -qq "${packageName}" > /dev/null 2>&1 &
    local last_pid=$!
    
    showProgress "${last_pid}"
    wait "${last_pid}" || print_exit 1 "Could not install ${packageName}."
    echo -e "${GREEN}Package ${packageName} installed.${NOCOLOR}"
}

# Executes Maven targets with the progress spinner
function mavenTarget(){
    local mavenCmd=${1}
    echo -e "${CYAN}Running Maven: mvn ${mavenCmd}...${NOCOLOR}"
    
    # Run maven in background
    mvn ${mavenCmd} > /dev/null 2>&1 &
    local last_pid=$!
    
    showProgress "${last_pid}"
    wait "${last_pid}" || print_exit 1 "Maven target '${mavenCmd}' failed."
    echo -e "${GREEN}Maven ${mavenCmd} completed successfully.${NOCOLOR}"
}

# NEW: Helper to verify deployment health
function checkDeployment() {
    local url=${1}
    echo -e "${CYAN}Verifying deployment at ${url}...${NOCOLOR}"
    if curl -s --head  --request GET "$url" | grep "200 OK" > /dev/null; then
        echo -e "${GREEN}Application is UP and running!${NOCOLOR}"
    else
        print_exit 1 "Application is not reachable at ${url}"
    fi
}
