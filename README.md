# Social Media Sentiment Analysis

## Project Overview
This project performs sentiment analysis on social media posts using advanced machine learning techniques. It leverages the CardiffNLP Twitter RoBERTa Base Sentiment Model to classify text into positive, negative, and neutral sentiments. The project also integrates a MySQL database to store and retrieve social media data and sentiment predictions.

## Objectives
- Build a real-time sentiment analysis pipeline.
- Use pre-trained transformer models for accurate sentiment classification.
- Store and manage social media data and predictions in a MySQL database.
- Automate the data flow from database retrieval to model inference and sentiment storage.

## Tools and Technologies Used
- **Programming Language**: Python
- **Machine Learning Libraries**:
  - Transformers (Hugging Face)
  - PyTorch
  - Scikit-learn
- **Data Manipulation**: Pandas
- **Database Management**:
  - MySQL
  - MySQL Connector for Python
- **Pre-trained Model**: CardiffNLP Twitter RoBERTa Base Sentiment Model
- **System Libraries**:
  - subprocess
  - sys

## Project Structure
```
|-- sentiment_analysis.py        # Main Python script
|-- requirements.txt             # List of dependencies
|-- README.md                    # Project documentation
```

## Installation and Setup
1. Clone the repository:
```bash
git clone https://github.com/yourusername/social-media-sentiment-analysis.git
cd social-media-sentiment-analysis
```
2. Create a virtual environment (optional but recommended):
```bash
python -m venv venv
source venv/bin/activate  # On Windows use `venv\Scripts\activate`
```
3. Install dependencies:
```bash
pip install -r requirements.txt
```

## Database Configuration
Ensure your MySQL server is running and the database is properly set up. Update the database connection parameters in the Python script:
```python
con = mysql.connector.connect(
    host='localhost',
    user='your_username',
    password='your_password',
    database='socialmediaanalysis',
    auth_plugin='mysql_native_password'
)
```

## Running the Project
To start the sentiment analysis pipeline:
```bash
python sentiment_analysis.py
```

## Usage
- The program fetches social media posts from the MySQL database.
- It uses the pre-trained RoBERTa model to predict sentiment (positive, negative, neutral).
- Predictions are stored in the `SentimentPredictions` table with confidence scores.
- You can also input custom text and receive real-time sentiment predictions.

## Future Improvements
- Implement a real-time streaming data pipeline.
- Add visualization dashboards with Power BI.
- Explore fine-tuning the sentiment model for better domain-specific accuracy.


