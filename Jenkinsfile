podTemplate(containers: [
    containerTemplate(name: 'maven', image: 'sunrdocker/jdk17-git-maven-docker-focal', command: 'sleep', args: '99d')
    containerTemplate(name: 'kubectl', image: 'uhub.service.ucloud.cn/uk8sdemo/kubectl:latest', command: 'cat', ttyEnabled: true),
  ],
  yaml: """\
apiVersion: v1
kind: Pod
metadata:
  name: kaniko
spec:
  containers:
  - name: kaniko
    image: uhub.service.ucloud.cn/uk8sdemo/executor:debug
    command:
    - cat
    tty: true
    volumeMounts:
      - name: kaniko-secret
        mountPath: /kaniko/.docker
  restartPolicy: Never
  volumes:
    - name: kaniko-secret
      secret:
        secretName: regcred
    """.stripIndent()

  )

  {
    node(POD_LABEL) {
        stage('Git Clone')
        {
            git branch: 'main', credentialsId: 'a9245f23-3644-4bc1-8ff3-9edd068958c9', url: 'https://github.com/DennnnyX/htmx.git'
        }
        stage('Compile')
        {
            container('maven')
            {
                stage('mvn packaging')
                {
                    sh 'mvn clean package'
                }
            }
        }
        stage('Build Into Image')
        {
            container('kaniko')
            {
                stage('Build With Kaniko')
                {
                    echo 'Hello kaniko'
                    sh "/kaniko/executor --dockerfile `pwd`/Dockerfile --context `pwd` --destination dennnys/pipeline:v1.1"
                }
            }
        }
        stage('Y A M L')
        {

        }
        stage('Deploy Into Pod')
        {
            container('kubectl')
            {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')])
                {
                     echo 'Check kubernetes pods'
                     sh 'mkdir -p ~/.kube && cp ${KUBECONFIG} ~/.kube/config'
                     sh 'kubectl get pods'
                     sh 'kubectl apply -f k8s.yaml'
                }

            }
        }

    }
}