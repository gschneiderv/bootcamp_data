
from functions import arguments, load_dataset, data_processing, mlflow_tracking

def main():
  print("Excuting main.py")
  args_values = arguments()
  df = load_dataset()
  X_train, X_test, y_train, y_test = data_processing(df)
  mlflow_tracking(args_values.name_job, X_train, X_test, y_train, y_test, args_values.c_values)

if __name__ == "__main__":
  main()
