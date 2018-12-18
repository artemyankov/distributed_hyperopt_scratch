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
    mongod --dbpath . --port $MONGO_DB_PORT --directoryperdb --fork --journal --logpath log.log --nohttpinterface

    echo "[+] Im a PS running Mongo"
else
    echo "[+] Im a worker ready for action..."
fi

while :; do
    if nc -z $MONGO_DB_HOST $MONGO_DB_PORT 2>/dev/null; then
        echo "server is up"
        hyperopt-mongo-worker --mongo=$MONGO_DB_HOST:$MONGO_DB_PORT/foo_db --poll-interval=0.5 --exp-key=$EXPERIMENT_NAME --max-consecutive-failures=9999 &
        python ./main.py
    else
        echo "server is down!"
    fi
done



