setwd("/Users/kateryna.shpir/Documents/GetCleanData/")

#extracting the data

#unzipping and accessing the data
install.packages("downloader")
install.packages("plyr")
library(downloader)

x<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download(x, dest="dataset.zip", mode="wb") 
unzip ("dataset.zip", exdir = "./GetCleanData")

path <- file.path("./GetCleanData", "UCI HAR Dataset")
files<-list.files(path, recursive=TRUE)
files

#reading data in Test
ActivityTst  <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
SubjectTst  <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)
FeaturesTst  <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)

#reading data in Training
ActivityTrn <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)
SubjectTrn <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
FeaturesTrn <- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)


#Merging the files
Subject <- rbind(SubjectTrn, SubjectTst)
Activity<- rbind(ActivityTrn, ActivityTst)
Features<- rbind(FeaturesTrn, FeaturesTst)

names(Subject)<-c("subject")
names(Activity)<- c("activity")
Featurenam <- read.table(file.path(path, "features.txt"),head=FALSE)
colnames(Features) <- t(FeaturesNames[2])

dataset <- cbind(Features, Activity, Subject)
colNames  = colnames(dataset)


#Extracting only the measurements on the mean and standard deviation for each measurement

meanSTDdata<-Featurenam$V2[grep("mean\\(\\)|std\\(\\)", Featurenam$V2)]
subdata<-c(as.character(meanSTDdata), "subject", "activity" )
dataset<-subset(dataset,select=subdata)

dim(dataset)


actlbl <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)

names(dataset)<-gsub("Mag", "Magnitude", names(dataset))
names(dataset)<-gsub("^f", "frequency", names(dataset))
names(dataset)<-gsub("Acc", "Accelerometer", names(dataset))
names(dataset)<-gsub("Gyro", "Gyroscope", names(dataset))
names(dataset)<-gsub("Mag", "Magnitude", names(dataset))
names(dataset)<-gsub("BodyBody", "Body", names(dataset))
names(dataset)<-gsub("^t", "time", names(dataset))
names(dataset)<-gsub("tBody", "TimeBody", names(dataset))
names(dataset)<-gsub("gravity", "Gravity", names(dataset))
names(dataset)<-gsub("-mean()", "Mean", names(dataset), ignore.case = TRUE)
names(dataset)<-gsub("-std()", "STD", names(dataset), ignore.case = TRUE)
names(dataset)<-gsub("-freq()", "Frequency", names(dataset), ignore.case = TRUE)
names(dataset)<-gsub("angle", "Angle", names(dataset))
names(dataset)

library(plyr)

datasetv2<-aggregate(. ~subject + activity, dataset, mean)
datasetv2<-datasetv2[order(datasetv2$subject,datasetv2$activity),]
write.table(datasetv2, file = "tidydata.txt",row.name=FALSE)
