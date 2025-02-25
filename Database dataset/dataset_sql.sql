-- Objective: Real-Time Social Media Sentiment Analysis and Trend Prediction with Machine Learning
-- This project captures live social media data, analyzes sentiment, and predicts trending topics using SQL for data management and deep learning models for sentiment classification.

-- Create the Social Media Analysis Database
CREATE DATABASE SocialMediaAnalysis;
USE SocialMediaAnalysis;

-- Create Users table
CREATE TABLE Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(50),
    Location VARCHAR(100),
    JoinDate DATE
);

-- Create Posts table
CREATE TABLE Posts (
    PostID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    Content TEXT,
    PostTime DATETIME,
    Sentiment VARCHAR(10), -- 'Positive', 'Negative', 'Neutral'
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Create Hashtags table
CREATE TABLE Hashtags (
    HashtagID INT PRIMARY KEY AUTO_INCREMENT,
    PostID INT,
    Hashtag VARCHAR(50),
    FOREIGN KEY (PostID) REFERENCES Posts(PostID)
);

-- Create SentimentPredictions table
CREATE TABLE SentimentPredictions (
    PredictionID INT PRIMARY KEY AUTO_INCREMENT,
    PostID INT,
    PredictedSentiment VARCHAR(10),
    Confidence DECIMAL(5,4),
    PredictionTime DATETIME,
    FOREIGN KEY (PostID) REFERENCES Posts(PostID)
);

-- Insert expanded sample data into Users table
INSERT INTO Users (Username, Location, JoinDate)
VALUES
('rohit_k', 'Mumbai, India', '2021-06-15'),
('priya_s', 'Delhi, India', '2020-08-22'),
('anita_g', 'Bangalore, India', '2019-04-10'),
('akash_r', 'Pune, India', '2023-01-05'),
('nisha_j', 'Hyderabad, India', '2022-07-19');

-- Insert expanded sample data into Posts table
INSERT INTO Posts (UserID, Content, PostTime, Sentiment)
VALUES
(1, 'Loving the weather in Mumbai today! ☀️', '2025-02-21 10:00:00', 'Positive'),
(2, 'Traffic in Delhi is unbearable today. 😡', '2025-02-21 14:30:00', 'Negative'),
(3, 'Excited for the upcoming tech conference in Bangalore!', '2025-02-20 09:45:00', 'Positive'),
(4, 'Had an amazing time at the music festival in Pune! 🎶', '2025-02-19 18:00:00', 'Positive'),
(5, 'Hyderabad’s food scene never disappoints! 🍽️', '2025-02-18 12:00:00', 'Positive'),
(2, 'Feeling frustrated with delayed flights. ✈️', '2025-02-22 20:30:00', 'Negative');

-- Insert expanded sample data into Hashtags table
INSERT INTO Hashtags (PostID, Hashtag)
VALUES
(1, '#MumbaiWeather'),
(2, '#DelhiTraffic'),
(3, '#TechConference'),
(4, '#PuneMusicFest'),
(5, '#HyderabadFoodie');

-- Identify trending hashtags
SELECT H.Hashtag, COUNT(H.Hashtag) AS UsageCount
FROM Hashtags H
JOIN Posts P ON H.PostID = P.PostID
WHERE P.PostTime > NOW() - INTERVAL 7 DAY
GROUP BY H.Hashtag
ORDER BY UsageCount DESC
LIMIT 5;

-- Sentiment distribution for the last 24 hours
SELECT Sentiment, COUNT(*) AS SentimentCount
FROM Posts
WHERE PostTime > NOW() - INTERVAL 1 DAY
GROUP BY Sentiment;

