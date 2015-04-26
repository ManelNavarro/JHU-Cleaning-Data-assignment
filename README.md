---
title: "run_analysis.R README"
author: "Manel Navarro"
output: html_document
---
### Scope
This script has been prepared as part of the **Getting and Cleaning Data** course of the **Johns Hopkins Bloomberg School of Health** and **Coursera**. 
Raw data used was collected from the accelerometers from the Samsung Galaxy S smartphone and it is available at:
[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

For details, see reference:
*Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012*

The script is intended to perform following tasks:

* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names. 
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Code Book
A description of all variables included in *tidy* dataset (output file **X2.txt**) is included in the **CodeBook.md** file.

### Input/Output files

#### Required input files
**IMPORTANT:** Script expects raw Data to be in working directory as downloaded from [project website](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) and unzipped, with folder name _**UCI HAR Dataset**_. 
Script will load following files:

#####working directory/UCI HAR Dataset/
* __Activity Labels.txt__: names corresponding to the activity codes in y_test.txt and y_train.txt
* __features.txt__: names of the measurements performed, in same order as columns in X_test and X_train data files
* __features_info.txt__: description of measurements in features.txt

#####working directory/UCI HAR Dataset/test/
* __y_test.txt__: activity codes corresponding to observations in X_test.txt data file
* __subject_test.txt__: Ids of subjects who performed the activity for each observation in X_test.txt data file
* __X_test.txt__: data set of test observations

#####working directory/UCI HAR Dataset/train/
* __y_train.txt__: activity codes corresponding to observations in X_train.txt data file
* __subject_train.txt__: Ids of subjects who performed the activity for each observation in X_train.txt data file
* __X_train.txt__: data set of test observations

#### Output file
Resulting dataset will be written into "**X2.txt**" file in working directory

###Script Description

#### Required packages
* __dplyr__

####Key steps
1. Load packages and read all required files
2. Add activity and subject codes to each dataset
3. Merge test and train datasets
4. Select only the mean and stdev measures
5. Replace activity Id with activity name in the Activity column
6. Add header with variable names as per features file
7. Create the second data set as average of first data set per activity and subject
8. Write second data set to file

####1. Load packages and read all required files
* Loads dplyr package
* Loads all files described above as dataframes using read.table(). Argument _colClasses="numeric"_ is used for faster reading with test and train datasets.
```
library(dplyr)
labels<-read.table("UCI HAR Dataset/activity_labels.txt")
features<-read.table("UCI HAR Dataset/features.txt")
y_test<-read.table("UCI HAR Dataset/test/y_test.txt")
sub_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
y_train<-read.table("UCI HAR Dataset/train/y_train.txt")
sub_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
```

####2. Add activity and subject codes to each dataset
As all three main files subject, activity and measures have the same number of rows for each dataset (test, train), *cbind()* function is used for simplicity. Columns are ordered as follows: Subject, ActivityId, ... (all measures on X files). The same process is applied to **test** and **train** datasets.
```
X_test<-cbind(sub_test,y_test,X_test)
X_train<-cbind(sub_train,y_train,X_train)
```

####3. Merge test and train datasets
As both datasets have the same variables, use *rbind()* for simplicity. Resulting merged dataset is "X".
Once datasets are merged, rename subject and activity columns for easier reference.
```
X<-rbind(X_test,X_train)
colnames(X)[1:2]<-c("Subject", "ActivityId")
```

####4. Select only the mean and stdev measures
+ To identify which columns of the merged dataset contain only mean and stdev measures, create a vector *selmeasures* with the position of each row in *features* table which contains "mean()" or "std()" keywords. As the order of the rows in *features* table corresponds to the order of the columns in the dataset, this vector can later be used for selecting and renaming columns.

        *Assumption*: It is understood that we do not want "meanFreq()" measures nor additional vectors obtained by averaging the signals in a signal window sample.
        
+ Create a second dataset using first two columns of X (*Subject*, *ActivityId*) and those columns of X with positions corresponding to *selmeasures* vector, shifted 2 columns to the right so as to start just after *ActivityId* column.

```
selmeasures<-grep("mean\\(\\)|std\\(\\)",features[,2])
X1<-X[,c(1:2,selmeasures+2)]
```

####5. Replace activity Id with activity name in the Activity column
Three steps:

+ Rename columns of *labels* table for easier reference.
+ Left Join dataset *X1* with *labels* table on *ActivityId* column (as name is common on both tables)
+ Replace ActivityIds with Activity names. Column with names is copied onto *ActivityId* to place it in second order of the Dataset, then last column with names is discarded and *ActivityId* is renamed as *Activity*.

```
colnames(labels)[1:2]<-c("ActivityId","Activity")
X1<-left_join(X1,labels,"ActivityId")
X1<-mutate(X1,ActivityId=Activity)
X1<-select(X1,-Activity)
X1<-rename(X1,Activity=ActivityId)
```

####6. Add header with variable names as per features file
The goal is to assign measure names from *features* table to columns of measures in *X1* dataset (starting from 3rd column).
To obtain the measure names corresponding to the columns, the *selmeasures* selection vector calculated in step **4** is used again, now to filter the right rownames of *features* table and assign them to colnames of *X1* dataset. Filtered rows from *features* table must be coerced into character as they are Factor.

```
colnames(X1)[3:length(X1)]<-as.character(features[selmeasures,2])
```

####7. Create the second data set as average of first data set per activity and subject
Group *X1* dataset by Subject and Activity. Summarise the resulting dataset applying *mean()* function to all measures and store the result into a second *X2* dataset. Used pipeline notation for easier reading.
Afterwards, rename all measure columns adding "Avg." prefix to differentiate from original measure.

```
X2<-
        X1 %>%
        group_by(Subject,Activity) %>%
        summarise_each(funs(mean))

colnames(X2)[3:length(X2)]<-paste("Avg.",colnames(X2)[3:length(X2)])
```        

####8. Write second data set to file

```
write.table(X2,file="X2.txt",row.name=FALSE)
```
