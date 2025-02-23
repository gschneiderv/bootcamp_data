
import argparse
import subprocess
import time
import mlflow
import mlflow.sklearn
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler

from sklearn.metrics import accuracy_score,f1_score, precision_score, recall_score
from sklearn.datasets import load_wine

def arguments():
    print("probaaandoo")
    parser = argparse.ArgumentParser(description='__main__ arguments as inputs')
    parser.add_argument('--name_job', type=str, help='Add name parameter of the job: name_job')
    parser.add_argument('--c_values', nargs='+', type=int, help='List of c_values')
    return parser.parse_args()

def load_dataset():
    wine = load_wine()
    df_wine = pd.DataFrame(wine['data'], columns=wine['feature_names'])
    df_wine['target'] = wine['target']
    return df_wine


def data_processing(df_wine):
    # Drop features with correlation >= 0.85
    df_wine.drop(columns='flavanoids', inplace=True)

    # Split data into features and target
    X = df_wine.drop(columns=['target'])
    y = df_wine['target']

    # Split into train and test sets
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)
    
    return X_train, X_test, y_train, y_test
    

def mlflow_tracking(name_job, X_train, X_test, y_train, y_test, c_values):
    mlflow_ui_process = subprocess.Popen(['mlflow', 'ui', '--port', '5000'])
    print(mlflow_ui_process)
    time.sleep(5)
    mlflow.set_experiment(name_job)
    for c in c_values:
        with mlflow.start_run() as run:
            pipeline = Pipeline([
            ('scaler', StandardScaler()),
            ('logistic_regression', LogisticRegression(C=c,solver= 'newton-cg',max_iter=1000,random_state=42, class_weight= 'balanced'))
            ])

            pipeline.fit(X_train, y_train)
            accuracy_train = pipeline.score(X_train, y_train)
            pipeline.score(X_test, y_test)
            y_pred = pipeline.predict(X_test)

            mlflow.log_metric('accuracy_train', accuracy_train)
            mlflow.log_param("C", c)
            mlflow.sklearn.log_model(pipeline, 'lr_model')
       
            accuracy = accuracy_score(y_test, y_pred)
            precision = precision_score(y_test, y_pred, average='weighted')
            recall = recall_score(y_test, y_pred, average='weighted')
            f1 = f1_score(y_test, y_pred, average='weighted')
            mlflow.log_metric("accuracy", accuracy)
            mlflow.log_metric("precision", precision)
            mlflow.log_metric("recall", recall)
            mlflow.log_metric("f1_score", f1)

    return print("Se ha acabado el entrenamiento del modelo correctamente")



