pipeline {
  agent {
    dockerfile {
      filename './docker/Dockerfile'
      label 'builder'
    }
  }
  parameters {
    string(name: 'release_type', defaultValue: 'patch', description: 'The release type: `major` `minor` `patch`')
  }
  environment {
    LEVEL = "${params.release_type}"
    STEP = "init"
  }

  stages {
    stage('Release') {
      steps {
        powershell(script: "./cli.sh release ${LABEL}", returnStdout: true)
      }
    }
    stage('Publish') {
      steps {
        powershell(script: './cli.sh publish', returnStdout: true)
      }
    }
  }
}
