## The project asks us to create an R script with the name "run_analysis.R" and perform the following steps:
##
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##########################################################################################
## Step 1: Merge the training and the test sets to create one data set.
##########################################################################################

## Read the data first
subject_train <- read.table("subject_train.txt")
subject_test <- read.table("subject_test.txt")
X_train <- read.table("X_train.txt")
X_test <- read.table("X_test.txt")
Y_train <- read.table("y_train.txt")
Y_test <- read.table("y_test.txt")

# Provide a column name for subject data.  Subject data is single column data file
names(subject_train) <- "subject_id"
names(subject_test) <- "subject_id"

# Provide column names for measurement files
features <- read.table("features.txt")
names(X_train) <- features$V2
names(X_test) <- features$V2

# Add column name for label files
names(Y_train) <- "activity"
names(Y_test) <- "activity"

# Combine files into one dataset
train_dataset <- cbind(subject_train, Y_train, X_train)
test_dataset <- cbind(subject_test, Y_test, X_test)
combined_dataset <- rbind(train_dataset, test_dataset)

######################################################################################################
## Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.
######################################################################################################

mean_std_columns <- grepl("mean\\(\\)", names(combined_dataset)) | grepl("std\\(\\)", names(combined_dataset))
mean_std_columns[1:2] <- TRUE
combined_dataset <- combined_dataset[, mean_std_columns]


######################################################################################################
## Step 3&4: Uses descriptive activity names to name the activities in the data set
######################################################################################################

activity_names <- c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying")
combined_dataset$activity <- factor(combined_dataset$activity, labels=activity_names)

######################################################################################################
## Step 5: From the data set in step 4, creates a second, independent tidy data set with the 
##         average of each variable for each activity and each subject.
######################################################################################################

m_dataset <- melt(combined_dataset, id=c("subject_id","activity"))
tidy_dataset <- dcast(m_dataset, subject_id+activity ~ variable, mean)

######################################################################################################
## Flush the final data set to a file
######################################################################################################
write.table(tidy_dataset, "tidy_data_set.csv", row.names=FALSE)


