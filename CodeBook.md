---
title: "CodeBook for run_analysis.R"
author: "Manel Navarro"
output: html_document
---

Tidy dataset in file **X2.txt** includes a total of 180 rows of 68 variables. Variables are divided in three types:

1. **Subject**: The Id of the subject who performed the activity for each window sample. 
+ Its range is from 1 to 30.
2. **Activity**: The name of the activity performed. It can have 6 values:
+ WALKING
+ WALKING_UPSTAIRS
+ WALKING_DOWNSTAIRS
+ SITTING
+ STANDING
+ LAYING
3. **Average Measures**: A list of 66 measures averaged per Subject and Activity. I.e. the average of all observations perfomed by each subject on each activity. The measures are just a selection of the original dataset, namely those containing means and standard deviations of the Samsung collected signals. Variable names are the same of the original experiment, with a **"mean()"** or **"std()"** suffix for the mean and standard deviation of the signals, respectively, and an **"Avg."** prefix to indicate these have been averaged across all observations per Subject and Activity. All variables are numeric. Original measures are normalized and bounded within [-1,1].

        Explanation of Samsung originally collected signals ("features")

        The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. 
        These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

        Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

        Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

        These signals were used to estimate variables of the feature vector for each pattern:  
        '-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

+ Avg. tBodyAcc-mean()-X
+ Avg. tBodyAcc-mean()-Y
+ Avg. tBodyAcc-mean()-Z
+ Avg. tBodyAcc-std()-X
+ Avg. tBodyAcc-std()-Y
+ Avg. tBodyAcc-std()-Z
+ Avg. tGravityAcc-mean()-X
+ Avg. tGravityAcc-mean()-Y
+ Avg. tGravityAcc-mean()-Z
+ Avg. tGravityAcc-std()-X
+ Avg. tGravityAcc-std()-Y
+ Avg. tGravityAcc-std()-Z
+ Avg. tBodyAccJerk-mean()-X
+ Avg. tBodyAccJerk-mean()-Y
+ Avg. tBodyAccJerk-mean()-Z
+ Avg. tBodyAccJerk-std()-X
+ Avg. tBodyAccJerk-std()-Y
+ Avg. tBodyAccJerk-std()-Z
+ Avg. tBodyGyro-mean()-X
+ Avg. tBodyGyro-mean()-Y
+ Avg. tBodyGyro-mean()-Z
+ Avg. tBodyGyro-std()-X
+ Avg. tBodyGyro-std()-Y
+ Avg. tBodyGyro-std()-Z
+ Avg. tBodyGyroJerk-mean()-X
+ Avg. tBodyGyroJerk-mean()-Y
+ Avg. tBodyGyroJerk-mean()-Z
+ Avg. tBodyGyroJerk-std()-X
+ Avg. tBodyGyroJerk-std()-Y
+ Avg. tBodyGyroJerk-std()-Z
+ Avg. tBodyAccMag-mean()
+ Avg. tBodyAccMag-std()
+ Avg. tGravityAccMag-mean()
+ Avg. tGravityAccMag-std()
+ Avg. tBodyAccJerkMag-mean()
+ Avg. tBodyAccJerkMag-std()
+ Avg. tBodyGyroMag-mean()
+ Avg. tBodyGyroMag-std()
+ Avg. tBodyGyroJerkMag-mean()
+ Avg. tBodyGyroJerkMag-std()
+ Avg. fBodyAcc-mean()-X
+ Avg. fBodyAcc-mean()-Y
+ Avg. fBodyAcc-mean()-Z
+ Avg. fBodyAcc-std()-X
+ Avg. fBodyAcc-std()-Y
+ Avg. fBodyAcc-std()-Z
+ Avg. fBodyAccJerk-mean()-X
+ Avg. fBodyAccJerk-mean()-Y
+ Avg. fBodyAccJerk-mean()-Z
+ Avg. fBodyAccJerk-std()-X
+ Avg. fBodyAccJerk-std()-Y
+ Avg. fBodyAccJerk-std()-Z
+ Avg. fBodyGyro-mean()-X
+ Avg. fBodyGyro-mean()-Y
+ Avg. fBodyGyro-mean()-Z
+ Avg. fBodyGyro-std()-X
+ Avg. fBodyGyro-std()-Y
+ Avg. fBodyGyro-std()-Z
+ Avg. fBodyAccMag-mean()
+ Avg. fBodyAccMag-std()
+ Avg. fBodyBodyAccJerkMag-mean()
+ Avg. fBodyBodyAccJerkMag-std()
+ Avg. fBodyBodyGyroMag-mean()
+ Avg. fBodyBodyGyroMag-std()
+ Avg. fBodyBodyGyroJerkMag-mean()
+ Avg. fBodyBodyGyroJerkMag-std()
