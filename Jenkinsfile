pipeline {
    agent { label 'centos-slave1'}
    options {
        ansiColor('xterm')
    }
    stages {
        stage ('Init') {
            steps {
                sh "terraform init -input=false"
            }
        }
        stage ('Plan') {
            steps {
                sh "terraform plan -out=tfplan -input=false"
            }
            
        }
        stage ('Apply changes') {
            steps {
                input 'Does this seems OK?'
                milestone(1)
                sh "terraform apply -input=false tfplan"
            }
            
        }
        
    }
}
