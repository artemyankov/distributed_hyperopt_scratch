import math
import os
from hyperopt import fmin, tpe, hp
from hyperopt.mongoexp import MongoTrials

print(os.environ)
def main():
    mongo_db_host = os.environ["MONGO_DB_HOST"]
    mongo_db_port = os.environ["MONGO_DB_PORT"]
    experiment_name = os.environ["EXPERIMENT_NAME"]

    mongo_process = "mongo://{0}:{1}/foo_db/jobs".format(mongo_db_host, mongo_db_port)

    trials = MongoTrials(mongo_process, exp_key=experiment_name)
    best = fmin(math.sin, hp.uniform('x', -2, 2), trials=trials, algo=tpe.suggest, max_evals=10)
    print(best)

if __name__ == "__main__":
    main()