podTemplate(name: 'jenkins-agent', cloud: 'kubernetes',
  namespace: 'devops-tools', label: '',
  serviceAccount: 'default', containers: [
  containerTemplate(
      name: 'jenkins-slave',
      image: 'harbor.59iedu.com/fjhb/jenkins-slave-toolkit:2018-08-10-v1',
      args: '${computer.jnlpmac} ${computer.name}',
      ttyEnabled: true,
      privileged: false,
      alwaysPullImage:true,
      )
  ])

{
  node('jenkins-slave')
  {
    stage('pull code')
    {
      container('jnlp')
      {
          echo 'pull code'
          git branch: 'main', credentialsId: 'a9245f23-3644-4bc1-8ff3-9edd068958c9', url: 'https://github.com/DennnnyX/htmx.git'
      }
    }

    stage('mvn-build')
    {
      container('jnlp')
      {
          echo 'mvn-build'
          sh 'mvn spring-boot:run'
      }
    }
  }
}