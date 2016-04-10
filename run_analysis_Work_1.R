library(plyr) # load plyr first, then dplyr 
library(data.table) # a prockage that handles dataframe better
library(dplyr) # for fancy data table manipulations and organization



if(!file.exists("./data")){
    dir.create("./data")
                          }
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")





# Unzip dataSet
unzip(zipfile="./data/Dataset.zip",exdir="./data")



# Read train tables
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Read test tables
X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Read features
features <- read.table('./data/UCI HAR Dataset/features.txt')


# Read activity labels
activity_labels = read.table('./data/UCI HAR Dataset/activity_labels.txt')


# X data set
x_Data_Set <- rbind(x_train,X_test)

# y data set
y_Data_Set <- rbind(y_train,y_test) 


# Subject data set
Subject_Data_Set <- rbind(subject_train, subject_test)


# Just bring columns include mean() or std() 
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])


# correct the column names

names(x_Data_Set) <- features[mean_and_std_features, 2]



# update values with correct activity names
y_Data_Set[, 1] <- activity_labels[y_Data_Set[, 1], 2]


# correct column name
names(y_Data_Set) <- "activity"


# correct column name
names(Subject_Data_Set) <- "subject"


# bind all the data 
All_Of_Them <- cbind(x_Data_Set, y_Data_Set, Subject_Data_Set)



Averages <- ddply(All_Of_Them, .(subject, activity), function(x) colMeans(x[, 1:66]))


# Create tidy data set
write.table(Averages, "Tidy_Data.txt", row.name=FALSE)





