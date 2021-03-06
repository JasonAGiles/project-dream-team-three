#!/usr/bin/env groovy

def performOnDockerServer(closure) {
  withCredentials([string(credentialsId: 'aws-docker-sandbox-url', variable: 'dockerUrl')]) {
    docker.withServer(dockerUrl, 'aws-docker-sandbox-certificate') {
      closure()
    }
  }
}

def output

node {
  stage('Checkout') {
    checkout scm
  }

  stage('Build') {
    performOnDockerServer() {
      output = docker.build 'project-dream-team-docker'
    }
  }

  stage ('Test') {
    performOnDockerServer() {
      sh 'docker run --rm --env FLASK_APP=run.py --env FLASK_CONFIG=production project-dream-team-docker tests.py'
    }
  }

  // stage ('Push') {
  //   performOnDockerServer() {
  //     docker.withRegistry('https://registry.hub.docker.com', 'jagiles-docker-registry') {
  //       output.push('latest')
  //     }
  //   }
  // }

  stage ('Deploy') {
    performOnDockerServer() {
      withCredentials([file(credentialsId: 'project-dream-team-docker-compose-prod', variable: 'dockerCompose')]) {
        sh """
        docker-compose -f docker-compose.yml -f ${dockerCompose} build
        docker-compose -f docker-compose.yml -f ${dockerCompose} up -d
        """
      }
    }
  }
}
