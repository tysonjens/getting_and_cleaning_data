## set up a new folder in a working directory
if (!file.exists("cloudfront")){dir.create("cloudfront")}

## download zip file to new folder "cloudfront"
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "./cloudfront/cloudfront.zip")

## extracts train and test sets
setwd("./cloudfront/")
unzip("cloudfront.zip")
test<- read.table("./UCI HAR Dataset/test/X_test.txt")
train <- read.table("./UCI HAR Dataset/train/X_train.txt")

##extract labels, combines labels & data, training & test
testlables <- read.table("./UCI HAR Dataset/test/y_test.txt")
trainlables <- read.table("./UCI HAR Dataset/train/y_train.txt")
testfull <- cbind(test, testlables)
trainfull <- cbind(train, trainlables)

fulldata <- rbind(testfull, trainfull)
columnheads <- read.table("./UCI HAR Dataset/features.txt")
columnheads <- columnheads[,2]

##load dplyr
library(dplyr)

## subsets data to only include means and standard deviations
slimfulldata <- fulldata[c(1:6,41:46,81:86,121:126,161:166,201:202,214:215,227:228,240:241,253:254,266:271,294:296,345:350,373:375,424:429,452:454,503:504,513,516:517,529:530,539,542:543,552,562)]
slimcolumnheads <- columnheads[c(1:6,41:46,81:86,121:126,161:166,201:202,214:215,227:228,240:241,253:254,266:271,294:296,345:350,373:375,424:429,452:454,503:504,513,516:517,529:530,539,542:543,552,562)]

##renames columns with more descriptive names
names(slimfulldata) <- slimcolumnheads
tolower(names(slimfulldata))
names(slimfulldata)[79] <- "activitynames"

##replaces values 1:6 with descriptive activities
slimfulldata$activitynames <- sub("1","walking",slimfulldata$activitynames)
slimfulldata$activitynames <- sub("2","walkupstairs",slimfulldata$activitynames)
slimfulldata$activitynames <- sub("3","walkdownstairs",slimfulldata$activitynames)
slimfulldata$activitynames <- sub("4","sitting",slimfulldata$activitynames)
slimfulldata$activitynames <- sub("5","standing",slimfulldata$activitynames)
slimfulldata$activitynames <- sub("6","laying",slimfulldata$activitynames)

##adds Subjects dimension to file
trainsubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
testsubjectss <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subjectcolumn <- rbind(testsubjectss, trainsubjects)
names(subjectcolumn) <- "Subjects"
slimfulldata <- cbind(subjectcolumn, slimfulldata)
install.packages("reshape")

##melts and casts data such that it can be summarized by subject, by activity
library(reshape)
trytomelt <- melt(slimfulldata, id= c("Subjects", "activitynames"))

castedbySubjects <- cast(trytomelt, Subjects~activitynames~variable, mean)
meltcasted <- melt(castedbySubjects, id=c("Subjects", "activitynames", "variables"))

write.table(meltcasted, "./tidydataset.txt", row.name=FALSE)
