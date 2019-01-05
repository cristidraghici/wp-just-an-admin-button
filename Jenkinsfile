pipeline {
  agent {
    dockerfile {
      filename './docker/Dockerfile'
    }
    label 'builder'
  }

  environment {
    LEVEL = 'patch'
  }

  stages {
    stage('Parse the input') {
      steps {
        patch = sh (script: "git log -1 | grep '\\[release patch\\]'", returnStatus: true)
        if (patch) { LEVEL = 'patch' }

        minor = sh (script: "git log -1 | grep '\\[release minor\\]'", returnStatus: true)
        if (patch) { LEVEL = 'minor' }

        major = sh (script: "git log -1 | grep '\\[release major\\]'", returnStatus: true)
        if (patch) { LEVEL = 'major' }
      }
    }

    stage('Create a new release on the repository') {
      when { branch 'master' }

      steps {
        echo 'Building..'
      }

      steps {
        sh "./cli.sh release $LEVEL"
      }
    }

    stage('Publish the new release to the Wordpress plugin repository') {
      when { branch 'master' }

      steps {
        echo 'Testing..'
      }

      steps {
        sh "./cli.sh publish"
      }
    }
  }
}
