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
    stage('Parse the input') {
      parallel {
        steps {
          if (sh (script: "git log -1 | grep '\\[release patch\\]'", returnStatus: true)) { LEVEL = 'patch' }
        }
        steps {
          if (sh (script: "git log -1 | grep '\\[release minor\\]'", returnStatus: true)) { LEVEL = 'minor' }
        }
        steps {
          if (sh (script: "git log -1 | grep '\\[release major\\]'", returnStatus: true)) { LEVEL = 'major' }
        }
      }
    }
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
