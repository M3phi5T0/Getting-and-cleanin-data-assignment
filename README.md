# Getting-and-cleaning-data-assignment
This repo contains the assignment from the Getting and Cleaning Data course offered by Johns Hopkins on Coursera

The script run_analysis.R does the following:

1) It directly downloads the data into your working directory incase the data doesn't exist
2) Reads the activity labels and feature data
3) Reads the training and test data sets and merges them
4) Binds the "Activity" and "Subject" columns to the merged data set
5) Extracts only the measurements on the mean and standard deviation for each measurement
6) Appropriately labels the data set with descriptive variable names
7) Creates an independent data set with the average of each variable for each activity and subject
8) Writes the independent data set in step 7 to a .txt file named "tidyData.txt" to upload on Coursera


