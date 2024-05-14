# Least Square SVR using Regression and Classification in MATLAB

## Application : Predicting wheather the Robot reaches the Goal or not by using SVR(Both Regression and Classification) in MATLAB

This repository presents a MATLAB implementation of Least Square Support Vector Regression (SVR) combined with classification for predicting whether a robot reaches its goal. The code utilizes a combination of regression and classification techniques to analyze robot motion data and make predictions about goal achievement. By implementing SVR for regression and classification tasks, the model can accurately predict both the position of the robot and whether it achieves its goal. This application has wide-ranging implications, particularly in robotics and autonomous systems, where accurate prediction of goal achievement is crucial for efficient operation and decision-making. Through this implementation, users can gain insights into the capabilities of SVR in handling regression and classification tasks simultaneously, enhancing their understanding of machine learning techniques applied to robotics applications.

### Overview

The code performs the following tasks:

- Reads data from a CSV file containing time, position, and goal achievement information for robot motion.
- Implements quadratic regression and Classification using SVR for position prediction.
- Classifies points based on goal achievement to create an epsilon tube.
- Calculates regression mean absolute error (MAE), classification accuracy, and epsilon tube accuracy.
- Displays the results and plots the regression curve with goal prediction and epsilon tube.

### Requirements

- MATLAB
- CVX (for convex optimization)

