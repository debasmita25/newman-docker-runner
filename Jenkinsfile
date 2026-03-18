pipeline {
    agent any

    parameters {
        choice(
            name: 'COLLECTION',
            choices: [
                'Collection_GitHub',
                'Collection_Other'
            ],
            description: 'Select Postman Collection'
        )
    }

    environment {
        DOCKER_IMAGE = "debasmita25/newman:latest"
        REPORT_PATH = "report/report.html"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Resolve Files') {
            steps {
                script {
                    if (params.COLLECTION == 'Collection_GitHub') {
                        env.COLLECTION_FILE = "collections/Collection_GitHub.postman_collection.json"
                        env.ENV_FILE = "environments/github-env.json"
                    } else {
                        env.COLLECTION_FILE = "collections/Collection_Other.postman_collection.json"
                        env.ENV_FILE = "environments/other-env.json"
                    }
                }
            }
        }

        stage('Debug Workspace') {
            steps {
                bat 'echo WORKSPACE: %WORKSPACE%'
                bat 'dir'
            }
        }

        stage('Pull Docker Image') {
            steps {
                bat "docker pull %DOCKER_IMAGE%"
            }
        }

        stage('Run Tests in Docker') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'api-creds',
                    usernameVariable: 'API_USERNAME',
                    passwordVariable: 'API_PASSWORD'
                )]) {

                    bat """
                    docker run --rm ^
                      -v "%WORKSPACE%:/etc/newman" ^
                      %DOCKER_IMAGE% ^
                      newman run %COLLECTION_FILE% ^
                      -e %ENV_FILE% ^
                      --env-var "GITHUB_USERNAME=%API_USERNAME%" ^
                      --env-var "GITHUB_PASSWORD=%API_PASSWORD%" ^
                      -r cli,html ^
                      --reporter-html-export report/report.html
                    """
                }
            }
        }
    }

    post {

        always {
            echo "Publishing report and archiving artifacts..."

            publishHTML([
                reportDir: 'report',
                reportFiles: 'report.html',
                reportName: 'Newman Report',
                keepAll: true,
                alwaysLinkToLastBuild: true,
                allowMissing: true
            ])

            archiveArtifacts artifacts: 'report/**', allowEmptyArchive: true
        }

        success {
            emailext (
                subject: "SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
                <h3>Build Successful</h3>
                <p><b>Job:</b> ${env.JOB_NAME}</p>
                <p><b>Build:</b> #${env.BUILD_NUMBER}</p>
                <p><b>Collection:</b> ${params.COLLECTION}</p>
                <p><a href="${env.BUILD_URL}">View Build</a></p>
                """,
                to: "debasmita25@example.com",
                mimeType: 'text/html',
                attachmentsPattern: 'report/*.html'
            )
        }

        failure {
            emailext (
                subject: "FAILURE: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
                <h3 style="color:red;">Build Failed</h3>
                <p><b>Job:</b> ${env.JOB_NAME}</p>
                <p><b>Build:</b> #${env.BUILD_NUMBER}</p>
                <p><b>Collection:</b> ${params.COLLECTION}</p>
                <p>Check console logs for error.</p>
                <p><a href="${env.BUILD_URL}">View Build</a></p>
                """,
                to: "debasmita25@gmail.com",
                mimeType: 'text/html',
                attachmentsPattern: 'report/*.html'
            )
        }
    }
}