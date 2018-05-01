node {
  def container
  def repo = 'christopherhein/aws-workshop-for-kubernetes'

  stage('Checkout') {
    checkout scm
  }

  def shortCommit = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()

  stage('Build Container') {
    container = docker.build(repo)
  }

  stage('Push Container') {
    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
      container.push(shortCommit)
      container.push("latest")
    }
  }

  stage('Test Code') {
    echo "add test command here"
  }

  stage('Scan Container') {
    twistlockScan ca: '', cert: '', compliancePolicy: 'warn', \
      dockerAddress: 'unix:///var/run/docker.sock', \
      ignoreImageBuildTime: false, key: '', logLevel: 'true', \
      policy: 'warn', repository: repo, \
      requirePackageUpdate: false, tag: shortCommit, timeout: 10
  }

  stage('Publish Container') {
    twistlockPublish ca: '', cert: '', \
      dockerAddress: 'unix:///var/run/docker.sock', key: '', \
      logLevel: 'true', repository: repo, tag: shortCommit, \
      timeout: 10
   }

  stage('Update k8s Config') {
    sh "sed -i 's/VERSION_NUMBER/${shortCommit}/g' configs/app.yml"
  }

  stage('Deploy k8s config') {
    sh 'kubectl apply -f configs/'
  }
}