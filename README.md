# Getting-and-cleaning-data-assignment
This repo contains the assignment from the Getting and Cleaning Data course offered by Johns Hopkins on Coursera

The script run_analysis.R does the following:

1) It directly downloads the data into your working directory incase the data doesn't exist
2) Reads the activity labels and feature data
3) Reads the training and test data sets and merges them
4) Binds the "Activity" and "Subject" columns to the merged data set
5) Appropriately labels the data set with descriptive variable names
6) Creates an independent data set with the average of each variable for each activity and subject
7) Writes the independent data set in step 6 to a .txt file to upload on Coursera


