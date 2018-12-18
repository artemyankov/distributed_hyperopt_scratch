import json

def main():
    test_dict = {'dog': 'bernese'}
    with open('test_json.json', 'w') as f:
        json.dump(json.dumps(test_dict), f)

    return


if __name__ == '__main__':
    main()