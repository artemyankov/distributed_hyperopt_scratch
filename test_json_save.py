import json
import os
from clusterone import get_logs_path

def main():
    test_dict = {'dog': 'bernese'}
    file_path = os.path.join(get_logs_path('./logs'), 'test_json.json')
    with open(file_path, 'w') as f:
        json.dump(json.dumps(test_dict), f)

    return


if __name__ == '__main__':
    main()