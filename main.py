import math
import os
import json
from hyperopt import fmin, tpe, hp
from hyperopt.mongoexp import MongoTrials
from pymongo.errors import ServerSelectionTimeoutError
from clusterone import get_logs_path

def main():
    mongo_db_host = os.environ["MONGO_DB_HOST"]
    mongo_db_port = os.environ["MONGO_DB_PORT"]
    experiment_name = os.environ["EXPERIMENT_NAME"]

    mongo_process = "mongo://{0}:{1}/foo_db/jobs".format(mongo_db_host, mongo_db_port)
    print(mongo_process)

    while True:
        try:
            trials = MongoTrials(mongo_process, exp_key=experiment_name)
        except ServerSelectionTimeoutError:
            pass
        else:
            best = fmin(math.sin, hp.uniform('x', -2, 2), trials=trials, algo=tpe.suggest, max_evals=10)

            if os.environ["JOB_NAME"] == "ps":
                best_path = get_logs_path("./logs")
                with open(os.path.join(best_path, "./best_val.txt"), "w") as f:
                    f.write(json.dumps(best))

            return

if __name__ == "__main__":
    main()