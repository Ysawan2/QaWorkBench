# QaWorkBench

QaWorkBench provides a containerized test environment with following capabilities...all in a single containerized environment:

- Connect to local k3d clusters
- Access secrets stored in vault and connect to cloud environments

- Run QA tests
- Generate logs and store in host mounted volume

## Workflow

- install dependencies
- deploy local cluster - k3d
- fetch secrets from hashicorp vault
- configure cloud clis
- install qa dependencies
- run qa tests
- gather logs and store in local volume
    -gather pytest logs
    -gather cluster logs
    -gather skupper logs
- expose logs from local webserver


 
