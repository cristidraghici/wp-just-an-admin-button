pipeline {
  agent {
    dockerfile {
      filename 'Dockerfile'
    }

  }
  stages {
    stage('Release') {
      parallel {
        stage('Release') {
          steps {
            echo 'Release a new version'
          }
        }
        stage('Execute the script command') {
          steps {
            sh './cli.sh release'
          }
        }
      }
    }
    stage('Publish') {
      parallel {
        stage('Publish') {
          steps {
            echo 'Publish the new version to the Wordpress repository'
          }
        }
        stage('Execute the script command') {
          steps {
            sh './cli.sh publish'
          }
        }
      }
    }
  }
  environment {
    VARIABLE_ENV = 'test'
  }
}