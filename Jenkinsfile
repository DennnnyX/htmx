podTemplate(containers: [
    containerTemplate(name: 'maven', image: 'jenkins/jnlp-agent-maven', command: 'sleep', args: '99d')
  ]) {

    node(POD_LABEL) {
        stage('Get a Demo') {
            sh 'java -version'
            git branch: 'main', credentialsId: 'a9245f23-3644-4bc1-8ff3-9edd068958c9', url: 'https://github.com/DennnnyX/htmx.git'
            container('maven') {
                stage('Build a Maven project') {
                    sh 'mvn spring-boot:run'
                }
            }
        }

    }
}