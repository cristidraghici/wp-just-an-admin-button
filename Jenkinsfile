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
        stage('default') {
          steps {
            echo 'Releasing...'
          }
        }
        stage('patch') {
          when {
            expression {
              sh(script: "git log -1 | grep 'release patch'", returnStatus: true) == true
            }
          }
          steps {
            sh(script: './cli.sh release patch', returnStdout: true)
          }
        }
        stage('minor') {
          when {
            expression {
              sh(script: "git log -1 | grep 'release minor'", returnStatus: true) == true
            }
          }
          steps {
            sh(script: './cli.sh release minor', returnStdout: true)
          }
        }
        stage('major') {
          when {
            expression {
              sh(script: "git log -1 | grep 'release major'", returnStatus: true) == true
            }
          }
          steps {
            sh(script: './cli.sh release major', returnStdout: true)
          }
        }
      }
    }
    stage('Publish') {
      steps {
        sh(script: './cli.sh publish', returnStdout: true)
      }
    }
    stage('Finish') {
      steps {
        echo 'Operation completed...'
      }
    }
  }
}
