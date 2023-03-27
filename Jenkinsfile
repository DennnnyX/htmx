podTemplate(containers: [
    containerTemplate(name: 'maven', image: 'sunrdocker/jdk17-git-maven-docker-focal', command: 'cat', ttyEnabled: 'true'),
    containerTemplate(name: 'kubectl', image: 'uhub.service.ucloud.cn/uk8sdemo/kubectl:latest', command: 'cat', ttyEnabled: 'true'),
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
                    sh 'java -version'
                    sh 'mvn -version'
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
                    echo 'Hello Kaniko'
                    echo 'Using Kaniko to Build Image'
                    sh "/kaniko/executor --dockerfile `pwd`/Dockerfile --context `pwd` --destination dennnys/pipeline:v1.1"
                }
            }
        }
        stage('Deploy Into Pod')
        {
            container('kubectl')
            {   //定义jenkins中的k8s config文件为变量名KUBE
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')])
                {
                     echo 'Check kubernetes pods'
                     sh 'mkdir -p ~/.kube && cp ${KUBECONFIG} ~/.kube/config' //拷贝k8s的credentional文件到新pod的目录下
                     sh 'kubectl get pods'
                     sh 'kubectl apply -f deploy.yaml'
                     sh 'kubectl get pods -n devops-tools'
                     sh 'kubectl get svc -n devops-tools'
                }

            }
        }

    }
}