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
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        // stage('Push Code to GitHub') {
        //     steps {
        //         withCredentials([usernamePassword(
        //             credentialsId: 'github-creds',
        //             usernameVariable: 'GIT_USER',
        //             passwordVariable: 'GIT_TOKEN'
        //         )]) {

        //             bat '''
        //             git config user.name "%GIT_USER%"
        //             git config user.email "jenkins@local"

        //             git add .
        //             git commit -m "Auto commit from Jenkins" || echo No changes

        //             git push https://%GIT_USER%:%GIT_TOKEN%@github.com/debasmita25/newman-docker-runner.git HEAD:master
        //             '''
        //         }
        //     }
        // }

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
                      -e GITHUB_USERNAME=%API_USERNAME% ^
                      -e GITHUB_PASSWORD=%API_PASSWORD% ^
 %DOCKER_IMAGE% ^
  newman run %COLLECTION_FILE%  ^
  -e %ENV_FILE% ^
  -r cli,html ^
  --reporter-html-export report/report.html """
                }
            }
        }

        stage('Publish Report') {
            steps {
                publishHTML([
                    reportDir: 'report',
                    reportFiles: 'report.html',
                    reportName: 'Newman Report',
                    keepAll: true,
                    alwaysLinkToLastBuild: true,
                    allowMissing: true
                ])
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'report/**', allowEmptyArchive: true
        }
    }
}