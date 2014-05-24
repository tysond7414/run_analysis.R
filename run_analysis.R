
#===============================================================================================

# Getting and Cleaning Data Class Assignment

#===============================================================================================

# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. 
# The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers 
# on a series of yes/no questions related to the project. You will be required to submit: 
# 1) a tidy data set as described below, 
# 2) a link to a Github repository with your script for performing the analysis, and 
# 3) a code book that describes the variables, the data, and any transformations or work that you performed 
# to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. 
# This repo explains how all of the scripts work and how they are connected.  

# One of the most exciting areas in all of data science right now is wearable computing - see for example 
# this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced 
# algorithms to attract new users. The data linked to from the course website represent data collected 
# from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the 
# site where the data was obtained: 

# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

# Here are the data for the project: 

# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

# You should create one R script called run_analysis.R that does the following. 

#===============================================================================================

# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive activity names. 

## Read in the Ydata
ytest<-read.table("/Users/Tyson/Desktop/DS3_Getting_and_Cleaning Data/UCI HAR Dataset/test/y_test.txt",header=F,col.names=c("ActivityID"))
ytr<-read.table("/Users/Tyson/Desktop/DS3_Getting_and_Cleaning Data/UCI HAR Dataset/train/y_train.txt",header=F,col.names=c("ActivityID"))

## Read in the Subject ID Data
SubTest<-read.table("/Users/Tyson/Desktop/DS3_Getting_and_Cleaning Data/UCI HAR Dataset/test/subject_test.txt",header=F,col.names=c("SubjectID"))
SubTr<-read.table("/Users/Tyson/Desktop/DS3_Getting_and_Cleaning Data/UCI HAR Dataset/train/subject_train.txt",header=F,col.names=c("SubjectID"))

## Read in the File Features with Column Names
det<-read.table("/Users/Tyson/Desktop/DS3_Getting_and_Cleaning Data/UCI HAR Dataset/features.txt", header=F, as.is=T, col.names=c("MeasureID", "MeasureName"))

## Read the X Data assigning column names from the features file
Xtest<-read.table("/Users/Tyson/Desktop/DS3_Getting_and_Cleaning Data/UCI HAR Dataset/test/X_test.txt",header=F, col.names=det$MeasureName)
Xtr<-read.table("/Users/Tyson/Desktop/DS3_Getting_and_Cleaning Data/UCI HAR Dataset/train/X_train.txt",header=F, col.names=det$MeasureName)

## Subset the column names
sub_det<- grep(".*mean\\(\\)|.*std\\(\\)", det$MeasureName)

## Subset the X data on the subset features
Xtest<-Xtest[,sub_det]
Xtr<-Xtr[,sub_det]

## Append the activity and Subject IDs
Xtest$ActivityID<-ytest$ActivityID
Xtest$SubjectID<-SubTest$SubjectID
Xtr$ActivityID<-ytr$ActivityID
Xtr$SubjectID<-SubTr$SubjectID

## Merge the update X files
data<-rbind(Xtest, Xtr)
cnames<-colnames(data)
cnames<-gsub("\\.+mean\\.+", cnames, replacement="Mean")
cnames<-gsub("\\.+std\\.+",  cnames, replacement="Std")
colnames(data)<-cnames

## Add an activiy names column
act<-read.table("/Users/Tyson/Desktop/DS3_Getting_and_Cleaning Data/UCI HAR Dataset/activity_labels.txt", header=F, as.is=T, col.names=c("ActivityID", "ActivityName"))
act$ActivityName<-as.factor(act$ActivityName)
lab_data<-merge(data,act)

#===============================================================================================

# Creates a second, independent tidy data set with the average of each variable for each 
# activity and each subject. 

library(reshape2)

## melt the dataset
id_vars=c("ActivityID", "ActivityName", "SubjectID")
measure_vars=setdiff(colnames(lab_data), id_vars)
melt_dat<-melt(lab_data, id=id_vars, measure.vars=measure_vars)

## recast 
recas<-dcast(melted_data, ActivityName + SubjectID ~ variable, mean)

## Create the tidy data set and save it on to the named file
write.table(recas,"/Users/Tyson/Desktop/DS3_Getting_and_Cleaning Data/UCI HAR Dataset/tidy_data.txt")

#===============================================================================================
