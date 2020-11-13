def releaseResources($msg) {
    echo "============================="
    echo $msg
    echo "... in ..."
    echo "${env.StageName}"
    echo "============================="
    sleep 10
}

pipeline {
    agent any
    options {
        skipStagesAfterUnstable()
    }
    stages {
        stage('Stage Build') {
            steps {
                script {
                    env.StageName = "${env.STAGE_NAME}"
                }
                echo "${env.STAGE_NAME}"
                echo 'Building..'
                echo "${params.PIPELINE_STRING}"
                sleep 20
            }
        }
        stage('Stage Test') {
            steps {
                echo 'Testing..'
                echo "${params.PIPELINE_STRING}"
                sleep 20
            }
        }
        stage('Stage Deploy') {
            steps {
                echo 'Deploying....'
                build job: 'Job_With_Parameters', parameters: [string(name: 'String', value: "${params.PIPELINE_STRING}")]
                sh "echo ${params.PIPELINE_STRING}"
                
                sleep 200
            }
        }
        stage('Parallel') {
            steps {
                parallel(
                    a:{
                        echo "Par 1"
                        sleep 4
                    },
                    b: {
                        echo "Par 2"
                        sleep 3
                    }
                    )
            }
        }
    }
    post {
        success {
            releaseResources('success')
        }
        cleanup {
            releaseResources('CleanUp')
        }
        aborted {
            releaseResources('aborted')
        }
    }    
}
