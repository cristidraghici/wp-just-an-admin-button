pipeline {
  agent {
    dockerfile {
      filename './docker/Dockerfile'
      label 'builder'
    }

  }
  stages {
    stage('Release') {
      parallel {
        stage('patch') {
          when {
            expression {
              sh(script: "git log -1 | grep 'release patch'", returnStatus: true)
            }

          }
          steps {
            powershell(script: './cli.sh release patch', returnStdout: true)
          }
        }
        stage('minor') {
          when {
            expression {
              sh(script: "git log -1 | grep 'release minor'", returnStatus: true)
            }

          }
          steps {
            powershell(script: './cli.sh release minor', returnStdout: true)
          }
        }
        stage('major') {
          when {
            expression {
              sh(script: "git log -1 | grep 'release major'", returnStatus: true)
            }

          }
          steps {
            powershell(script: './cli.sh release major', returnStdout: true)
          }
        }
      }
    }
    stage('Publish') {
      steps {
        powershell(script: './cli.sh publish', returnStdout: true)
      }
    }
    stage('Finish') {
      steps {
        echo 'Operation completed...'
      }
    }
  }
}