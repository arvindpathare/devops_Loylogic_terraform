pipeline {
    agent any
    stages {
        stage('code_checkin_build') {
            steps {
                sh '''git clone https://github.com/spring-projects/spring-petclinic.git
				cd spring-petclinic
				./mvnw package'''
            }
        }
		stage('DOCKER') {
            steps {
                sh '''
				cd $WORKSPACE
				git clone https://github.com/arvindpathare/devops_Loylogic_terraform.git
				docker build -t arvindpathare/springio
				docker push arvindpathare/springio'''
            }
        }
		stage('create_Infraand deploy_app') {
            steps {
                sh '''
				cd $WORKSPACE
				git clone https://github.com/arvindpathare/devops_Loylogic_terraform.git
				terraform init
				terraform apply -input=false tfplan
				git add -A
				git commit -m "tfstae$BUILD_NUMBER"
				git push origin master'''
            }
        }
    }
}