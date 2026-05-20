pipeline {
    agent any

    environment {
        // Derive org and repo from the Git remote URL
        REMOTE_URL = sh(script: "git config --get remote.origin.url", returnStdout: true).trim()
        ORG  = sh(script: "echo ${REMOTE_URL} | sed -E 's#https://github.com/([^/]+)/.*#\\1#'", returnStdout: true).trim()
        REPO = sh(script: "echo ${REMOTE_URL} | sed -E 's#.*/([^/]+)\\.git#\\1#'", returnStdout: true).trim()
    }

stage('Init Repo Protection') {
    when {
        expression { fileExists('.jenkins/first-run.flag') }
    }
    steps {
        withCredentials([usernamePassword(credentialsId: 'github-creds',
                                          usernameVariable: 'ADMIN_USER',
                                          passwordVariable: 'GITHUB_TOKEN')]) {
            sh """
                # 1) Update stack.yml
                /opt/scripts/update-stack.sh ${REPO} ${ORG}

                # 2) Remove first-run flag
                /opt/scripts/remove-flag.sh ${REPO} ${ORG}

                # 3) Apply branch protection
                /opt/scripts/branch-protection.sh ${REPO} ${ORG}
            """
        }
    }
}


        stage('Checkout') {
            when {
                not { expression { fileExists('.jenkins/first-run.flag') } }
            }
            steps { checkout scm }
        }

        stage('Build') {
            when {
                not { expression { fileExists('.jenkins/first-run.flag') } }
            }
            steps { sh './gradlew faasBuild' }
        }

        stage('Docker Push') {
            when {
                allOf {
                    branch 'main'
                    not { expression { fileExists('.jenkins/first-run.flag') } }
                }
            }
            steps { sh './gradlew faasPush' }
        }
    }
}
