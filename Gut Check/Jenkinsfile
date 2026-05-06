pipeline {
agent any

environment {
AWS_DEFAULT_REGION = 'us-east-1'
TF_IN_AUTOMATION = 'true'
}

stages {
    stage('Set credentials') {
        steps {
            withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: 'terraform-cautchy']]) {
                ```sh
                echo "AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID - AWS credentials set successfully"
                aws sts get-caller-identity
                ```
            }
        }
    }

    stage('Checkout code') {
        steps {
            checkout scm
            echo 'Repository checked out successfully'
        }
    }

    stage('Terraform Init') {
        steps {
            withCredentials([[
                $class: 'AmazonWebServicesCredentialsBinding',
                credentialsId: 'terraform-cautchy']]) {
                    sh '''
                    cd "Gut Check/Terraform"
                    terraform init
                '''
            }
        }
    }

    stage('Terraform Plan') {
        steps {
            withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: 'terraform-cautchy']]) {
                sh '''
                cd "Gut Check/Terraform"
                terraform plan
                '''
            }
        }
    }

    stage('Terraform Apply') {
        steps {
            withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: 'terraform-cautchy']]) {
                sh '''
                cd "Gut Check/Terraform"
                 terraform apply -auto-approve
                '''
            }
        }
    }

    stage('Armageddon Clearance') {
        steps {
            echo 'Armageddon clearance confirmed — artifacts deployed to S3'
            echo 'Armageddon Repo: https://github.com/jdpayne68/class-7-armageddon-tko-group/tree/main'
            }
        }
    }

post {
    success {
        echo 'Pipeline completed successfully!'
        echo 'Armageddon Repo: https://github.com/jdpayne68/class-7-armageddon-tko-group/tree/main'
        echo 'Artifacts deployed to S3'
        }

    failure {
        echo 'Pipeline failed — check logs above'
        }
    }
}
