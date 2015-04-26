##run_analysis.r

##IMPORTANT: Script expects raw Data to be in working directory
##as downloaded from website and unzipped, with folder name "UCI HAR Dataset"
##Resulting dataset will be written to working directory
##Script will load following files:

##working directory/UCI HAR Dataset --------
##Activity Labels.txt: names corresponding to the activity codes in y_test.txt and y_train.txt
##features.txt: names of the measurements performed, in same order as columns in X_test and X_train data files
##features_info.txt: description of measurements in features.txt

##working directory/UCI HAR Dataset/test ----
##y_test.txt: activity codes corresponding to observations in X_test.txt data file
##subject_test.txt: Ids of subjects who performed the activity for each observation in X_test.txt data file
##X_test.txt: data set of test observations

##working directory/UCI HAR Dataset/train ---
##y_train.txt: activity codes corresponding to observations in X_train.txt data file
##subject_train.txt: Ids of subjects who performed the activity for each observation in X_train.txt data file
##X_train.txt: data set of test observations

##Key steps of script:

##1) Load packages and read all required files
##2) Add activity and subject codes to each dataset
##3) Merge test and train datasets
##4) Select only the mean and stdev measures
##5) Replace activity Id with activity name in the Activity column
##6) Add header with variable names as per features file
##7) Create the second data set as average of first data set per activity and subject
##8) Write second data set to file

##1) Load packages and read all required files--------------------------

##load required packages
library(dplyr)

##read all required files
labels<-read.table("UCI HAR Dataset/activity_labels.txt")
features<-read.table("UCI HAR Dataset/features.txt")
y_test<-read.table("UCI HAR Dataset/test/y_test.txt")
sub_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
y_train<-read.table("UCI HAR Dataset/train/y_train.txt")
sub_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
X_test<-read.table("UCI HAR Dataset/test/X_test.txt", colClasses="numeric") #reads faster with explicit column classes
X_train<-read.table("UCI HAR Dataset/train/X_train.txt", colClasses="numeric")        

##2) Add activity and subject codes to each dataset------------------------
##as number of rows is the same, using cbind for simplicity
##order of columns: subject, activity, measures
X_test<-cbind(sub_test,y_test,X_test)
X_train<-cbind(sub_train,y_train,X_train)

##3) Merge test and train datasets-----------------------------------------
##as both have same variables, use rbind for simplicity
##new dataset is named "X"
X<-rbind(X_test,X_train)

##rename subject and activity columns
colnames(X)[1:2]<-c("Subject", "ActivityId")

##4) Select only mean and stdev for each measurement-----------------------

##First, identify which columns contain mean and stdev measures using "features" table
##Create a vector with the position of each row in "features" which contains "mean" or "std" keywords
selmeasures<-grep("mean\\(\\)|std\\(\\)",features[,2])

##Select into X1 all columns of X based on selmeasures, shifting+2 since Subject and Activity are the 2 initial columns
X1<-X[,c(1:2,selmeasures+2)]

##5) Replace ActivityId with Activity name in the Activity column----------

##rename label columns
colnames(labels)[1:2]<-c("ActivityId","Activity")

##Join dataset with labels table on ActivityId
X1<-left_join(X1,labels,"ActivityId")

##Replace ActivityId with Activity name
X1<-mutate(X1,ActivityId=Activity)
X1<-select(X1,-Activity)
X1<-rename(X1,Activity=ActivityId)

##6) Add header with variable names as per features file--------------------
##Assign measure names from feature to columns of measures in dataset (starting from 3rd column)
##Obtain mesure names with same selection vector used to select relevant measures, applied to features table
##Use as.character to transform factor into string
colnames(X1)[3:length(X1)]<-as.character(features[selmeasures,2])

##7) Create the second data set as average of first data set per activity and subject--------------
X2<-
        X1 %>%
        group_by(Subject,Activity) %>%
        summarise_each(funs(mean))

##change variable names of new data set to average of measure
colnames(X2)[3:length(X2)]<-paste("Avg.",colnames(X2)[3:length(X2)])

##8) Write second data set to file------------------------------------------
write.table(X2,file="X2.txt",row.name=FALSE)

