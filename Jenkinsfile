pipeline {
    agent any
    
    tools {
        maven 'Maven' 
    }
    
    stages {
        stage("Modernize & Test"){
            steps {
                slackSend channel: 'youtubejenkins', message: 'Job Started'
                
                // CRITICAL: Fix for Tomcat 10 compatibility (The Jakarta Shift)
                // This replaces javax.servlet with jakarta.servlet in all Java files
                sh "find src/main/java -name '*.java' -exec sed -i 's/javax.servlet/jakarta.servlet/g' {} +"
                sh "find src/main/java -name '*.java' -exec sed -i 's/javax.annotation/jakarta.annotation/g' {} +"
                
                sh "mvn test"
            }
        }
        
        stage("Build"){
            steps {
                // Ensure pom.xml is using Spring Boot 3.x for best results
                sh "mvn clean package -DskipTests"
            }
        }
        
        stage("Deploy on Test"){
            steps {
                // NOTE: Use tomcat10 adapter if your Jenkins plugin supports it.
                // If the plugin only shows tomcat9, the 'Modernize' step above 
                // ensures the WAR is compatible with the physical Tomcat 10 server.
                deploy adapters: [tomcat9(credentialsId: 'tomcatserverdetails1', path: '', url: 'http://192.168.0.118:8080')], 
                       contextPath: '/app', 
                       war: 'target/*.war'
            }
        }
        
        stage("Deploy on Prod"){
            input {
                message "Should we continue to Production?"
                ok "Yes, deploy to Prod"
            }
            steps {
                deploy adapters: [tomcat9(credentialsId: 'tomcatserverdetails1', path: '', url: 'http://192.168.0.119:8080')], 
                       contextPath: '/app', 
                       war: 'target/*.war'
            }
        }
    }
    
    post {
        success {
            slackSend channel: 'youtubejenkins', message: 'Deployment Success!'
        }
        failure {
            slackSend channel: 'youtubejenkins', message: 'Deployment Failed'
        }
    }
}
