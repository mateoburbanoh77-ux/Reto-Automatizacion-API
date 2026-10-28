pipeline {
   agent any
   tools {
       jdk 'Java21'
       maven 'Maven3'
   }
   options {
       disableConcurrentBuilds()
       buildDiscarder(logRotator(numToKeepStr: '10'))
       timeout(time: 15, unit: 'MINUTES')
   }
   triggers {
       pollSCM('H/5 * * * *')
   }
   stages {
       stage('Verificar herramientas') {
           steps {
               bat 'java -version'
               bat 'mvn -version'
               bat 'git --version'
           }
       }
       stage('Ejecutar pruebas API') {
           steps {
               bat 'mvn -B clean test'
           }
           post {
               always {
                   archiveArtifacts(
                       artifacts: 'target/karate-reports/**',
                       allowEmptyArchive: true
                   )
                   junit(
                       testResults: 'target/surefire-reports/TEST-*.xml',
                       allowEmptyResults: false
                   )
               }
           }
       }
   }
}