pipeline {
  agent {
    dockerfile {
      filename './docker/Dockerfile'
    }

    label 'builder'
  }

  parameters {
    string(name: 'release_type', defaultValue: 'patch', description: 'The release type: `major` `minor` `patch`')
  }

  environment {
    LEVEL = params.release_type
    STEP = 'init'
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
      when {
        branch 'master'

        expression {
          STEP == 'init'
        }

        expression {
          LEVEL == 'patch' || LEVEL == 'minor' || LEVEL == 'major'
        }
      }

      steps {
        echo 'Building..'
      }

      steps {
        sh "./cli.sh release $LEVEL"
      }

      steps {
        STEP = 'release'
      }
    }

    stage('Publish the new release to the Wordpress plugin repository') {
      when {
        expression {
          STEP == 'release'
        }
      }

      steps {
        echo 'Publishing..'
      }

      steps {
        sh "./cli.sh publish"
      }

      steps {
        STEP = 'publish'
      }
    }
  }
}
