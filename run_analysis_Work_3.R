dataSet <- "Data" ##recited of the data directory
resultSet <- "Result" ##the result is written to the directory


##the Result directory do we have?
if(!file.exists(resultSet)){
        print("create Result folder")
        dir.create(resultSet)
} 

#text convert to data.frame
txt_to_dataframe <- function (filename,cols = NULL){
        print(paste("Taken table:", filename))
        textFile <- paste(dataSet,filename,sep="/")
        dataFile <- data.frame()
        if(is.null(cols)){
                dataFile <- read.table(textFile,sep="",stringsAsFactors=F)
        } else {
                dataFile <- read.table(textFile,sep="",stringsAsFactors=F, col.names= cols)
        }
        dataFile
}

#run and check txt_to_dataframe
features <- txt_to_dataframe("features.txt")

#read data and build database
read_and_build <- function(type, features){
        print(paste("Taken data", type))
        subject_data <- txt_to_dataframe(paste(type,"/","subject_",type,".txt",sep=""),"id")
        datay <- txt_to_dataframe(paste(type,"/","y_",type,".txt",sep=""),"activity")
        datax <- txt_to_dataframe(paste(type,"/","X_",type,".txt",sep=""),features$V2)
        return (cbind(subject_data,datay,datax))
}

#run and check read_and_build
test <- read_and_build("test", features)
train <- read_and_build("train", features)

#save data
save_data <- function (data,name){
        print(paste("saving results", name))
        file <- paste(resultSet, "/", name,".csv" ,sep="")
        write.csv(data,file)
}

### required activities ###

#1) Merges the training and the test sets to create one data set.
library(plyr)
data <- rbind(train, test)
data <- arrange(data, id)

#2) Extracts only the measurements on the mean and standard deviation for each measurement. 
mean_and_std <- data[,c(1,2,grep("std", colnames(data)), grep("mean", colnames(data)))]
save_data(mean_and_std,"mean_and_std")

#3) Uses descriptive activity names to name the activities in the data set
activity_labels <- txt_to_dataframe("activity_labels.txt")

#4) Appropriately labels the data set with descriptive variable names. 
data$activity <- factor(data$activity, levels=activity_labels$V1, labels=activity_labels$V2)

#5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
tidy_dataset <- ddply(mean_and_std, .(id, activity), .fun=function(x){ colMeans(x[,-c(1:2)]) })
colnames(tidy_dataset)[-c(1:2)] <- paste(colnames(tidy_dataset)[-c(1:2)], "_mean", sep="")
save_data(tidy_dataset,"tidy_dataset")