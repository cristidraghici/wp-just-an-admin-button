pipeline {
  agent {
    dockerfile {
      filename './docker/Dockerfile'
      label 'builder'
    }
  }

  stages {
    stage('Release') {
      steps {
        if (powershell (script: "git log -1 | grep '\\[release patch\\]'", returnStatus: true)) {
          powershell(script: "./cli.sh release patch", returnStdout: true)
        }
        if (powershell (script: "git log -1 | grep '\\[release minor\\]'", returnStatus: true)) {
          powershell(script: "./cli.sh release minor", returnStdout: true)
        }
        if (powershell (script: "git log -1 | grep '\\[release major\\]'", returnStatus: true)) {
          powershell(script: "./cli.sh release major", returnStdout: true)
        }
      }
    }
    stage('Publish') {
      steps {
        powershell(script: './cli.sh publish', returnStdout: true)
      }
    }
  }
}
