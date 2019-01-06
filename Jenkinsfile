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
        sh "chmod +x ${WORKSPACE}/cli.sh"
      }
    }

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
            sh  "./cli.sh release patch"
          }
        }
        stage('minor') {
          when {
            expression {
              sh(script: "git log -1 | grep 'release minor'", returnStatus: true) == true
            }
          }
          steps {
            sh  "./cli.sh release minor"
          }
        }
        stage('major') {
          when {
            expression {
              sh(script: "git log -1 | grep 'release major'", returnStatus: true) == true
            }
          }
          steps {
            sh  "./cli.sh release major"
          }
        }
      }
    }

    stage('Publish') {
      steps {
        sh  "./cli.sh publish"
      }
    }

    stage('Finish') {
      steps {
        echo 'Operation completed...'
      }
    }
  }
}
