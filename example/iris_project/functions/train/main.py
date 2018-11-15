import json
import numpy as np
from sklearn import datasets
from sklearn.linear_model import LogisticRegression


def entry_point(event, context):
    # https://scikit-learn.org/stable/auto_examples/linear_model/plot_iris_logistic.html
    parameters = get_parameters(event)

    iris = datasets.load_iris()
    X = iris.data
    Y = iris.target

    logistic_regression = LogisticRegression(C=1e5, solver='lbfgs', multi_class='multinomial')
    logistic_regression.fit(X, Y)
    if parameters["ops"] == "train":
        score = logistic_regression.score(X, Y)
        return build_response(statusCode=200, body={"score": score})
    else:
       preds = logistic_regression.predict( np.array( parameters["input"] ) )
       classes = [ iris.target_names[x] for x in preds ]
       return build_response(statusCode=200, body={"preds": classes}) 

def get_parameters(event, key='body'):
    body = event.get(key)

    if body:
        if type(body) == str:
            body = json.loads(body)
        if not body.get("ops"):
            body["ops"] = "train"
        return body
    else:
        return { "ops": "train" }

def build_response(base64=False, statusCode=400, body={}):
    return { 'isBase64Encoded': False, "statusCode": statusCode, "body": json.dumps(body) }