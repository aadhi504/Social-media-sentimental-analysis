import subprocess
import sys
modules = [
    "transformers",
    "torch",
    "pandas",
    "sklearn",
    "mysql-connector-python"
]

for module in modules:
    subprocess.check_call([sys.executable, "-m", "pip", "install", module])

# Install and import necessary libraries

def install_and_import(package):
    try:
        __import__(package)
    except ImportError:
        subprocess.check_call([sys.executable, "-m", "pip", "install", package])
        __import__(package)

# Ensure necessary libraries are installed and imported
for package in ["transformers", "torch", "pandas", "sklearn", "mysql-connector-python"]:
    install_and_import(package)

import pandas as pd
import sklearn
import torch
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, classification_report
import mysql.connector
from transformers import pipeline as hf_pipeline
from transformers import AutoModelForSequenceClassification, AutoTokenizer



con = mysql.connector.connect(
    host='localhost',
    user = 'root',
    password = '938300',
    database = 'socialmediaanalysis',
    auth_plugin='mysql_native_password'
   )
print("database connection successfull")   
cur = con.cursor()



# Load posts data
try:
    query = "SELECT PostID, Content, Sentiment FROM Posts WHERE Sentiment IS NOT NULL"
    data = pd.read_sql(query, con)
except Exception as e:
    print(f"Error loading data from database: {e}")
    exit()

# Preprocess data
X = data['Content']
y = data['Sentiment']

# Load a more advanced transformer model for sentiment analysis
model_name = "cardiffnlp/twitter-roberta-base-sentiment"
try:
    tokenizer = AutoTokenizer.from_pretrained(model_name)
    model = AutoModelForSequenceClassification.from_pretrained(model_name)
except Exception as e:
    print(f"Error loading model: {e}")
    exit()

# Sentiment labels for this specific model
labels = ['negative', 'neutral', 'positive']

# Load new posts and predict sentiment
try:
    new_posts_query = "SELECT PostID, Content FROM Posts WHERE Sentiment IS NULL"
    new_posts = pd.read_sql(new_posts_query, con)

    if not new_posts.empty:
        for i, row in new_posts.iterrows():
            inputs = tokenizer(row['Content'], return_tensors='pt')
            outputs = model(**inputs)
            scores = torch.nn.functional.softmax(outputs.logits, dim=-1)
            sentiment_result = labels[scores.argmax().item()]
            confidence = scores.max().item()

            insert_query = """
            INSERT INTO SentimentPredictions (PostID, PredictedSentiment, Confidence, PredictionTime)
            VALUES (%s, %s, %s, NOW())
            """
            con.cursor.execute(insert_query, (row['PostID'], sentiment_result, confidence))
            con.commit()
except Exception as e:
    print(f"Error processing new posts: {e}")

con.close()

# Test with user input
while True:
    user_input = input("Enter a sentence to analyze sentiment (or type 'exit' to quit): ")
    if user_input.lower() == 'exit':
        break
    try:
        inputs = tokenizer(user_input, return_tensors='pt')
        outputs = model(**inputs)
        scores = torch.nn.functional.softmax(outputs.logits, dim=-1)
        sentiment_result = labels[scores.argmax().item()]
        confidence = scores.max().item()
        print(f"Text: {user_input} -> Predicted Sentiment: {sentiment_result} with confidence {confidence:.2f}")
    except Exception as e:
        print(f"Error processing user input: {e}")


