pipeline {
  agent {
    dockerfile {
      filename './docker/Dockerfile'
    }

  }
  stages {
    stage('Release') {
      steps {
        git(url: 'https://github.com/cristidraghici/wp-just-an-admin-button', branch: 'master')
        dir(path: 'wp-just-an-admin-button') {
          powershell(script: './cli.sh release minor', returnStdout: true)
        }

      }
    }
    stage('Publish') {
      steps {
        git(url: 'https://github.com/cristidraghici/wp-just-an-admin-button', branch: 'master')
        dir(path: 'wp-just-an-admin-button') {
          powershell(script: './cli.sh publish', returnStdout: true)
        }

      }
    }
  }
  environment {
    LEVEL = 'patch'
    STEP = 'init'
  }
}