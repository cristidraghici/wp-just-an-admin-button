pipeline {
  agent {
    dockerfile {
      filename './docker/Dockerfile'
      label 'builder'
    }

  }
  stages {
    stage('Prepare') {
      steps {
        echo 'Branch check is done in the scripts run.'
        echo 'To save resources, this should be moved to jenkins'
      }
    }
    stage('Release') {
      parallel {
        stage('default') {
          steps {
            echo 'This step is skipped if the commit message does not contain the `release` instruction'
          }
        }
        stage('patch') {
          when {
            expression {
              sh(script: "git log -1 | grep 'release patch'", returnStatus: true) == true
            }

          }
          steps {
            sh './cli.sh release patch'
          }
        }
        stage('minor') {
          when {
            expression {
              sh(script: "git log -1 | grep 'release minor'", returnStatus: true) == true
            }

          }
          steps {
            sh './cli.sh release minor'
          }
        }
        stage('major') {
          when {
            expression {
              sh(script: "git log -1 | grep 'release major'", returnStatus: true) == true
            }

          }
          steps {
            sh './cli.sh release major'
          }
        }
      }
    }

    stage('Publish') {
      steps {
        checkout scm
        sh 'cp .env.example .env'
        sh 'chmod +x ./cli.sh'

        withCredentials(bindings: [
                    string(credentialsId: 'WP_ORG_USERNAME', variable: 'WP_ORG_USERNAME'),
                    string(credentialsId: 'WP_ORG_PASSWORD', variable: 'WP_ORG_PASSWORD')
                  ]) {
            sh './cli.sh publish'
          }

        }
      }

      stage('Finish') {
        steps {
          echo 'Operation completed...'
        }
      }
    }
  }
