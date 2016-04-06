library(plyr)
## Download and unzipp the files
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename <- "project.zip"
download.file(fileurl, filename)
unzip(filename)

# Variable names
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])
v <- c("Subject","Activity")
vnames <- vector(mode = "character", length = length(v)+length(features[,2]))
vnames[1:length(v)] <- v
vnames[length(v)+1:length(features[,2])] <- features[,2]

# Create a data frame fot test
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt")
test_activity <- read.table("UCI HAR Dataset/test/y_test.txt")
test <- read.table("UCI HAR Dataset/test/X_test.txt")
test <- cbind(test_subject, test_activity, test)
names(test) <- vnames
test$set <- "test"

# Create a data frame fot train
train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt")
train_activity <- read.table("UCI HAR Dataset/train/y_train.txt")
train <- read.table("UCI HAR Dataset/train/X_train.txt")
train <- cbind(train_subject, train_activity, train)
names(train) <- vnames
train$set <- "train"

# Merge the two data sets
merged <- rbind(test,train)

# Extract mean and standard deviation
meanv <- grep("mean()", names(merged))
stdv <- grep("std()", names(merged))
ex <- merged[, c(1, 2, meanv, stdv, grep("set",names(merged)))]

# Name activities
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
ex$Activity <- as.factor(ex$Activity)
levels(ex$Activity)<- activities[,2]

# Descriptive vaiable names
names(ex) <- sub("^t","Time",names(ex))
names(ex) <- sub("^f","Frequency",names(ex))

# Summarize
averages_data <- ddply(ext, .(Subject, Activity), function(x) colMeans(x[, 3:81]))

