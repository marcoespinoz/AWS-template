pipeline {
    agent { label 'centos-slave1'}
    options {
        ansiColor('xterm')
    }
    stages {
        stage ('init') {
            steps {
                sh "terraform init -input=false"
            }
        }
        stage ('plan') {
            steps {
                sh "terraform plan -out=tfplan -input=false"
            }
            
        }
        stage ('apply') {
            steps {
                input 'Does this seems OK?'
                milestone(1)
                sh "terraform apply -input=false tfplan"
            }
            
        }
        
    }
}
