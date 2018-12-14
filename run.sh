#!/usr/bin/env bash

#export MONGO_DB_HOST==$(echo $PS_HOSTS | awk -F ':' '{print $1}')
#export MONGO_DB_PORT=27017
#export EXPERIMENT_NAME="howdy"

if [[ $JOB_NAME == "ps" ]]; then
    # install mongo and open up port
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
    echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list
    apt-get update
    apt-get install -y mongodb-org
    mongod --fork --logpath ./mongod.log --port $MONGO_DB_PORT
   # mongod --port 5000 &

    echo "[+] Im a PS running Mongo"
else
    echo "[+] Im a worker ready for action..."
    hyperopt-mongo-worker --mongo=$MONGO_DB_HOST:$MONGO_DB_PORT/foo_db --poll-interval=0.1
    #python examples/parallel-examples/bianchini/runner.py
fi