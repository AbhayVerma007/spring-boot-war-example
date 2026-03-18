#!/bin/bash
. ./scripts/utils.sh
. ./scripts/variables.sh

function clean_up(){
    rm -rf ./target
    echo -e "${GREEN}Clean up successful.${NOCOLOR}"
}

trap "clean_up;exit 2" 2

# 1. Permission Check (Adjusted for Jenkins)
if [[ $UID != 0 ]]; then
    echo "Warning: Not running as root. This may fail to install packages or copy to /var/lib/."
fi

# 2. Modernize the Code (The Jakarta Shift)
# This fixes the 404 error by converting the code for Tomcat 10
echo "Converting code for Tomcat 10 compatibility..."
find src/main/java -name "*.java" -exec sed -i 's/javax.servlet/jakarta.servlet/g' {} +

# 3. Repository Update
apt-get update > /dev/null &
showProgress $!
wait $!

# 4. Install Modern Stack (Using Tomcat 10)
installPackage maven
installPackage tomcat10  # Changed from tomcat9

# 5. Build
mavenTarget clean test package

# 6. Smart Deployment
APP_CONTEXT=${1:-app}
TARGET_WAR="target/hello-world-0.0.1-SNAPSHOT.war"
TOMCAT_DIR="/var/lib/tomcat10/webapps"

if cp -rf "$TARGET_WAR" "$TOMCAT_DIR/${APP_CONTEXT}.war"; then
    echo "Application Deployed successfully to Tomcat 10."
    echo "Access it on http://localhost:8080/${APP_CONTEXT}"
else
    echo "Failed to deploy. Check if /var/lib/tomcat10 exists."
    exit 1
fi

clean_up
exit 0
