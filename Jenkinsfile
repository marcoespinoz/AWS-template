pipeline {
    agent { label 'centos-slave1'}
    options {
        ansiColor('xterm')
    }
    stages {
 /*       stage ('git') {
            steps {
                sh "rm -rf /home/jenkins/jenknis_slave/workspace/terraform/AWS-template && git clone git@github.com:marko-espi/AWS-template.git"
            }
        }*/
        stage ('init') {
            steps {
                sh "terraform init -input=false AWS-template/"
            }
        }
        stage ('plan') {
            steps {
                sh "terraform plan -out=AWS-template/tfplan -input=false AWS-template/"
            }
            
        }
        stage ('apply') {
            steps {
                input 'Does this seems OK?'
                milestone(1)
                sh "terraform apply -input=false AWS-template/tfplan"
            }
            
        }
        
    }
}
