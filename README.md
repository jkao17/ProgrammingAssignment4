# ProgrammingAssignment4
# Getting and Cleaning Data Course Project

# Notes
The purpose of run_analysis.R:
 * Merges the training and the test sets to create one data set.
 * Extracts only the measurements on the mean and standard deviation foreach measurement. 
 * Uses descriptive activity names to name the activities in the data set
 * Appropriately labels the data set (dfcombo) with descriptive variable names.
 * From the data set in step 4, creates a second, independent tidy data set (dfsummary)
  with the average of each variable for each activity and each subject.

files were downloaded from
"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
and unzipped into folder "data" on Sun Oct 01 16:22 2017


# Method of Analysis

## Load required libraries
dplyr, data.table, tibble, and reshape2

## read in 8 files
 1) activity_labels.txt
 2) features.txt
 3) test/subject_test.txt
 4) test/X_test.txt
 5) test/y_test.txt
 6) train/subject_train.txt
 7) train/X_train.txt
 8) train/y_train.txt

## rename columns
Columns for some of the files were renamed to indicate the activity, subject, and
activity descriptions.

## find column numbers with "mean" and "std"
"grep" was used in order to determine which columns of data thate were needed from the
X_test and Y_test files.  Specifically, only those columns with names that included
the text "mean" or "std" were selected.  Since the assignment instructions were not
explicit, I chose to include the vectors from averaging the signals in a signal window
(samplegravityMean, tBodyAccMean, tBodyAccJerkMean, tBodyGyroMean, tBodyGyroJerkMean).

## get titles for columns with "mean" and "std"
"grep" was also used in order to get the associated titles for the X_test and X_train
files.  These were extracted from features.txt

## creating the dfcombo dataframe
At this point, it seemed easiest to create several dataframes, then to stitch them
together.  I'm sure there is a more elegant solution than the one I chose, but this
seemed to work correctly and kept the data in order.

### create tables containing "mean" and "std"
Four tables were created.
* trainmean holds columns with "mean" data from the X_train table
* trainstd holds columns "std" data from the X_train table
* testmean holds columns with "mean" data from the X_test table
* teststd holds columns "std" data from the X_test table

### apply titles to the tables
The titles (extracted from features.txt) were applied to the four tables described
in the previous step.

### combine subject, activity, mean, and std into dfcombo
Here again, I know there is probably a cleaner, less verbose way to stitch the
data together. I also chose to assume that when looking for the mean and standard
deviation, that it did not matter when the data was taken (during testing or during
training).  Activity descriptions were added as a column to the end of the data
frame dfcombo using merge.  Each variable forms a column, and each observation forms
a row.

## create summary table: dfsummary
"aggregate" was used to create a table with the mean of each variable for each
activity and each subject.  Following the order described in the assignment,
activity descriptions are in Group.1 and subject identifications are in Group.2.


## References
 * https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/
