# getting_and_cleaning_data
Getting and Cleaning Data final assignment

This r.script downloads a zip file that contains data for a test and train group.
Each subject (30 total) wore a phone during 6 activities.
The data from the phone's accelerometer was recorded in over 500 variables.

The script combines data into one data.frame, and subsets it to only include 79 variables.
Then it melts and casts the data to summarize each variable (mean) by subject, by activity.
