#!/usr/bin/env bash

export MONGO_DB_HOST==$(echo $PS_HOSTS | awk -F ':' '{print $1}')
export MONGO_DB_PORT=5000

echo $TYPE
echo $JOB_NAME

if [[ $TYPE == "ps" ]]; then
    # install mongo and open up port
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
    echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list
    apt-get update
    apt-get install -y mongodb-org
    mongod --port 5000

    echo "[+] Im a PS running Mongo"
else
    echo "[+] Im a worker ready for action..."
    #python examples/parallel-examples/bianchini/runner.py
fi