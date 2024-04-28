pipeline {
    agent any
    
    stages {
        stage ('Compile') {
            steps {
                git branch: 'main', url: 'https://github.com/Ganeevi/terraform_project.git'
            }
        }
        stage ('t-init') {
            steps {
                sh 'terraform init --reconfigure'
            }
        }
        stage ('t-plan'){
            steps {
                sh 'terraform plan'
            }
        }
        stage ('action') {
            steps {
                //sh 'echo "terraform action is ${Action}"'
                sh ("terraform apply --auto-approve")
            }
            post {
                success {
                    sh "terraform destroy --auto-approve"
                }
            }
        }
    }
}