#/bin/bash

# Create a temporary directory for the demo, then copy the demo files into it: docker-compose.yml, and .env
GIT_HOME=$PWD
echo $GIT_HOME
export DEMO_HOME=$(mktemp -d)
echo $DEMO_HOME
export APP_PATH=$DEMO_HOME
cd $DEMO_HOME
cp $GIT_HOME/docker-compose.yaml .
#cp $GIT_HOME/demo.sh .
cp $GIT_HOME/.env .

docker compose --env-file .env --project-name k1s-lp-demo up -d
