

train = read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
train[,562] = read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
train[,563] = read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

test = read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
test[,562] = read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
test[,563] = read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

activityLabels = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

# Read features file, cleanup a little
features = read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])

# Merge training and test sets together
fullData = rbind(train, test)

# only need the data on mean and std. dev.
colsWeWant <- grep(".*Mean.*|.*Std.*", features[,2])
# First define the set of features table 
features <- features[colsWeWant,]
# Now add the last two columns (subject and activity)
colsWeWant <- c(colsWeWant, 562, 563)
# And remove the unwanted columns from the full data set
fullData <- fullData[,colsWeWant]
# Add the column names (features) to fullData
colnames(fullData) <- c(features$V2, "Activity", "Subject")
colnames(fullData) <- tolower(colnames(fullData))

currentActivity = 1
for (currentActivityLabel in activityLabels$V2) {
  fullData$activity <- gsub(currentActivity, currentActivityLabel, fullData$activity)
  currentActivity <- currentActivity + 1
}

fullData$activity <- as.factor(fullData$activity)
fullData$subject <- as.factor(fullData$subject)

tidyData = aggregate(fullData, by=list(activity = fullData$activity, subject=fullData$subject), mean)
# get rid of the colums we dont need
tidyData[,90] = NULL
tidyData[,89] = NULL
write.table(tidyData, "tidyData.txt", sep="\t")