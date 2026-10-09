pipeline {
    agent any

    // ---------- Build triggers ----------
    triggers {
        githubPush()                 // webhook: build on every push to GitHub
        pollSCM('H/5 * * * *')       // fallback: poll the repository every ~5 minutes
        cron('H 2 * * 1-5')          // nightly build on weekdays at about 02:00
    }

    options {
        timestamps()
        timeout(time: 15, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    environment {
        PACKAGE = 'model-package.tar.gz'
    }

    stages {
        stage('Checkout') {
            steps { checkout scm }
        }
        stage('Lint') {
            steps { sh 'python3 lint.py' }
        }
        stage('Test') {
            steps { sh 'python3 -m unittest discover -v tests' }
        }
        stage('Quality gate') {
            steps { sh 'python3 train.py configs/production.yaml 0.95' }
        }
        stage('Build package') {
            steps { sh 'tar czf $PACKAGE train.py configs deploy.sh' }
        }
        // ---------- Deployment steps ----------
        stage('Deploy') {
            when { branch 'main' }   // only deploy from main
            steps { sh './deploy.sh $BUILD_NUMBER $PACKAGE' }
        }
    }

    // ---------- Post-build actions ----------
    post {
        always {
            archiveArtifacts artifacts: 'model-package.tar.gz', allowEmptyArchive: true
            cleanWs()
        }
        success {
            echo "Build #${env.BUILD_NUMBER} deployed successfully"
            mail to: 'team@example.com',
                 subject: "SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "Deployment finished. Details: ${env.BUILD_URL}"
        }
        failure {
            mail to: 'team@example.com',
                 subject: "FAILED: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "Build failed. Console output: ${env.BUILD_URL}console"
        }
    }
}
