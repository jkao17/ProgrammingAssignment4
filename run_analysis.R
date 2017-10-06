# Getting and Cleaning Data Course Project
#
# run_analysis.R

# Purpose:
#  1.	Merges the training and the test sets to create one data set.
#  2.	Extracts only the measurements on the mean and standard deviation for
#       each measurement. 
#  3.	Uses descriptive activity names to name the activities in the data set
#  4.	Appropriately labels the data set (dfcombo) with descriptive variable
#       names.
#  5.	From the data set in step 4, creates a second, independent tidy data
#       set (dfsummary) with the average of each variable for each activity
#       and each subject.

# libraries needed
   library(dplyr)
   library(data.table)
   library(tibble)
   library(reshape2)

# files were downloaded from
# "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# and unzipped into folder "data" on Sun Oct 01 16:22 2017

# read in 8 files
# 1) activity_labels.txt
# 2) features.txt
# 3) test/subject_test.txt
# 4) test/X_test.txt
# 5) test/y_test.txt
# 6) train/subject_train.txt
# 7) train/X_train.txt
# 8) train/y_train.txt

if(!file.exists("data")) {dir_create("data")}
activitylabels <- read.table("./data/activity_labels.txt")
features <- read.table("./data/features.txt")
subjecttest <- read.table("./data/test/subject_test.txt")
xtest <- read.table("./data/test/x_test.txt")
ytest <- read.table("./data/test/y_test.txt")
subjecttrain <- read.table("./data/train/subject_train.txt")
xtrain <- read.table("./data/train/x_train.txt")
ytrain <- read.table("./data/train/y_train.txt")

# rename columns
colnames(ytrain) <- c("activity")
colnames(ytest) <- c("activity")
colnames(subjecttrain) <- c("subject")
colnames(subjecttest) <- c("subject")
colnames(activitylabels) <- c("num","activitydesc")

# find column numbers with "mean" and "std"
selectmean <- grep("mean", features$V2)
selectstd <- grep("std", features$V2)

# get titles for columns with "mean" and "std"
titlemean <- grep("mean", features$V2, value = TRUE)
titlestd <- grep("std", features$V2, value = TRUE)

# create "train" tables containing "mean" and "std"
trainmean <- select(xtrain, selectmean)
trainstd <- select(xtrain, selectstd)

# create "test" tables containing "mean" and "std"
testmean <- select(xtest, selectmean)
teststd <- select(xtest, selectstd)

# apply titles to the tables
colnames(trainmean) <- titlemean
colnames(trainstd) <- titlestd

colnames(testmean) <- titlemean
colnames(teststd) <- titlestd

# combine subject, activity, mean, and std into single dataframe
dftest <- subjecttest
dftest <- cbind(dftest, ytest)
dftest <- cbind(dftest, testmean)
dftest <- cbind(dftest, teststd)

dftrain <- subjecttrain
dftrain <- cbind(dftrain, ytrain)
dftrain <- cbind(dftrain, trainmean)
dftrain <- cbind(dftrain, trainstd)

dfcombo <- rbind(dftest, dftrain)
dfcombo <- arrange(dfcombo, subject, activity)

# apply activity descriptions (task 4)
dfcombo = merge(dfcombo, activitylabels,
                by.x = "activity",
                by.y = "num",
                all = TRUE)

# mean of each variable for each activity and each subject (task 5)

dfsummary <- aggregate(dfcombo[3:81],
                       list(dfcombo$activitydesc, dfcombo$subject),
                       mean,
                       data = narrow)

