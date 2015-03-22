# Project assignment
# You should create one R script called run_analysis.R that does the following:

# 1: Merges the training and the test sets to create one data set.
# 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3: Uses descriptive activity names to name the activities in the data set
# 4: Appropriately labels the data set with descriptive variable names. 
# 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## Initialization
# Load packages
library(data.table)
library(reshape2)


# Get the current working directory
mystartwd <- getwd()

# Set the current working directory manually
# Uncomment below line and manually set your directory if needed
# mystartwd <-"D:/My Backups/Tech/Coursera/Getting and Cleaning Data/Getting and Cleaning Data/Course Project/"

setwd(mystartwd)


## Get the project data
dirName  <- "UCI HAR Dataset"
fileUrl  <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fileName <- "getdata_projectfiles_UCI HAR Dataset.zip"

if(file.exists(dirName)) { 
  warning("Directory already exist: script has backup exiting directory and download new files")
  file.rename(dirName, paste(dirName, format(Sys.time(), "%Y%m%d%H%M%S"), sep="_"))
  # Download the project data zip file
  download.file(fileUrl, fileName, mode = "wb")
  # Unzip downloaded zip file to dirName folder
  unzip(fileName,exdir = mystartwd)
  
} else {
  # Download the project data zip file
  download.file(fileUrl, fileName, mode = "wb")
  # Unzip downloaded zip file to dirName folder
  unzip(fileName,exdir = mystartwd)
}

pathInDir <- file.path(mystartwd, dirName)

## Read the data files
# First read the subject files
dtSubjectTest  <- fread(file.path(pathInDir, "test" , "subject_test.txt"))
dtSubjectTrain <- fread(file.path(pathInDir, "train" , "subject_train.txt"))

# Second read the activity (labels) files
dtActivityTest  <- fread(file.path(pathInDir, "test" , "Y_test.txt"))
dtActivityTrain <- fread(file.path(pathInDir, "train" , "Y_train.txt"))

# Third read the test and training data sets
dfTest  <- read.table(file.path(pathInDir, "test" , "X_test.txt"))
dfTrain <- read.table(file.path(pathInDir, "train" , "X_train.txt"))
# Convert the data frames to data tables
dtTest  <- data.table(dfTest)
dtTrain <- data.table(dfTrain)

## Merges the training and the test sets to create one data set
# First: row bind the subject data tables
dtSubject <- rbind(dtSubjectTest, dtSubjectTrain)
setnames(dtSubject, "V1", "subject")

# Second: row bind the activity data tables
dtActivity <- rbind(dtActivityTest, dtActivityTrain)
setnames(dtActivity, "V1", "activity_nr")

# Third: row bind the test and training data sets
dtMergeData <- rbind(dtTest, dtTrain)

# Fourth: column bind the test and training data sets
dtMergeSubject <- cbind(dtSubject, dtActivity)
dtMerge <- cbind(dtMergeSubject, dtMergeData)

# Specify keys for the merged dataset
setkey(dtMerge, subject, activity_nr)

## Extracts only the measurements on the mean and standard deviation for each measurement
dtFeature <- fread(file.path(pathInDir, "features.txt"))
setnames(dtFeature, names(dtFeature), c("feature_nr", "featureName"))

# Subset only the functions mean = mean() and standard deviation = std()
dtFeature <- dtFeature[grepl("mean\\(\\)|std\\(\\)", featureName)]

# Map the column numbers in the merged dataset to the feature number in a new variable (feature_cd)

dtFeature$feature_cd <- dtFeature[, paste0("V", feature_nr)]
#dtFeature$feature_cd

# Subset the data using the variable names
select <- c(key(dtMerge), dtFeature$feature_cd)
dtSub <- dtMerge[, select, with=FALSE]

## Uses descriptive activity names to name the activities in the data set

# Use the labels in the activity_labels.txt file as descriptive names for the activities
dtActivityName <- fread(file.path(pathInDir, "activity_labels.txt"))
setnames(dtActivityName, names(dtActivityName), c("activity_nr", "activityName"))

# Merge the activity labels
dtSub <- merge(dtSub, dtActivityName, by="activity_nr", all.x=TRUE)

# Update the key of the Sub data table by adding activityName
setkey(dtSub, subject, activity_nr, activityName)


## Appropriately labels the data set with descriptive variable names

dtMelt <- data.table(melt(dtSub, key(dtSub), variable.name="feature_cd"))
dt <- merge(dtMelt, dtFeature[, list(feature_nr, feature_cd, featureName)], by="feature_cd", all.x=TRUE)

## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

setkey(dt, subject, activityName)

#dtTidy <- dt[, list(average = mean(value), count = .N), by=key(dt)]
dtTidy <- dt[, list(average = mean(value)), by=key(dt)]

write.table(dtTidy, file = "tidyDataSet.txt",  sep="\t", row.names=FALSE)

# Create codebook
# library(knitr)
# knit("makeCodebook.Rmd", output="codebook.md", encoding="ISO8859-1", quiet=TRUE)

