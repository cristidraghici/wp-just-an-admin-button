pipeline {
  agent {
    dockerfile {
      filename './docker/Dockerfile'
    }

  }
  stages {
    stage('Release') {
      steps {
        powershell(script: './cli.sh release minor', returnStdout: true)
      }
    }
    stage('Publish') {
      steps {
        powershell(script: './cli.sh publish', returnStdout: true)
      }
    }
  }
  environment {
    LEVEL = 'patch'
    STEP = 'init'
  }
}