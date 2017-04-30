library(data.table)
library(dplyr)
library(reshape2)

fileName <- "getdata_dataset.zip"

## Download and unzip the file in the current working directory
if (!file.exists(fileName)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, fileName, mode = "wb")
}  

if (!file.exists("UCI HAR Dataset")) { 
  unzip(fileName) 
}

## Reading features.txt and activity_labels.txt
featureNames <- read.table("UCI HAR Dataset/features.txt")
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")

## Reading Training data
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
activityTrain <- read.table("UCI HAR Dataset/train/y_train.txt")
featuresTrain <- read.table("UCI HAR Dataset/train/X_train.txt")

## Reading Test data
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
activityTest <- read.table("UCI HAR Dataset/test/y_test.txt")
featuresTest <- read.table("UCI HAR Dataset/test/X_test.txt")  

## PART 1 - Merges the training and the test sets to create one data set
## Merging Training and Test datasets
subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
features <- rbind(featuresTrain, featuresTest)

## Naming the columns with data from features.txt
colnames(features) <- t(featureNames[2])

## Assigning column names to subject and activity
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"


## Merging all the subsets (Features, activity and subject) together
finalData <- cbind(features, activity, subject)

## PART 2 - Extracts only the measurements on the mean and standard deviation
## Finding columns with either "Mean" or "Standard Deviation" in their names
columnsWithMeanSD <- grep(".*mean.*|.*std.*", names(finalData), ignore.case=TRUE)

## Adding activity and subject columns to the previous list
finalColumns <- c(columnsWithMeanSD, 562, 563)

 
## for each measurement.
## We create the extracted data with the finalColumns i.e Mean, SD,
## activity and subject columns
extractedData <- finalData[,finalColumns]

## PART 3 - Uses descriptive activity names to name the activities in the data set
## Now we need to replace the numeric values for activity with labels from
## activityLabels
extractedData$Activity <- as.character(extractedData$Activity)

## For activity values 1:6 we replace the numeric value with the 
## corresponding label
for (i in 1:6){
  extractedData$Activity[extractedData$Activity == i] <- as.character(activityLabels[i,2])
}


## Changing the activity variable into a factor
extractedData$Activity <- as.factor(extractedData$Activity)

## PART 4 - Appropriately labels the data set with descriptive variable names
names(extractedData)<-gsub("Acc", "Accelerometer", names(extractedData))
names(extractedData)<-gsub("Gyro", "Gyroscope", names(extractedData))
names(extractedData)<-gsub("BodyBody", "Body", names(extractedData))
names(extractedData)<-gsub("Mag", "Magnitude", names(extractedData))
names(extractedData)<-gsub("^t", "Time", names(extractedData))
names(extractedData)<-gsub("^f", "Frequency", names(extractedData))
names(extractedData)<-gsub("tBody", "TimeBody", names(extractedData))
names(extractedData)<-gsub("-mean()", "Mean", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-std()", "SD", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-freq()", "Frequency", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("angle", "Angle", names(extractedData))
names(extractedData)<-gsub("gravity", "Gravity", names(extractedData))

## PART 5 - From the data set in step 4, creates a second, independent tidy
## data set with the average of each variable for each activity and each subject

## Changing subject into a factor variable
extractedData$Subject <- as.factor(extractedData$Subject)
extractedData <- data.table(extractedData)

## Lets melt and recast the data into our second independent set
## Let the second data set be called tidyData
meltedData <- melt(extractedData, id = c("Subject", "Activity"))
tidyData <- dcast(meltedData, Subject + Activity ~ variable, mean)

## Writing our tidyData to a .txt file
write.table(tidyData, file = "tidyData.txt", row.names = FALSE)
