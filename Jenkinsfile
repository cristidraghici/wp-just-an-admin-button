#!/usr/bin/env groovy

pipeline {
  agent {
    dockerfile {
      filename './docker/Dockerfile'
      label 'builder'
    }
  }

  environment {
    BRANCH="${env.BRANCH_NAME}"
  }

  stages {
    stage('Prepare') {
      stage('branch') {
        when {
          expression {
            BRANCH != 'master'
          }
        }
        steps {
          echo 'Branch must be master for build to work.';
          exit 1;
        }
      }
      stage('checkout') {
        steps {
          checkout scm
          sh "chmod +x ./cli.sh"
        }
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
        withCredentials([
          string(credentialsId: 'WP_ORG_USERNAME', variable: 'WP_ORG_USERNAME'),
          string(credentialsId: 'WP_ORG_PASSWORD', variable: 'WP_ORG_PASSWORD')
        ]) {
          checkout scm
          sh "./cli.sh publish"
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
