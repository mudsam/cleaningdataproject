###
### Purpose
### Merge, label and summarize the "UCI HAR Dataset"
### The output contains the calculated mean by subject and activity of the means and standard deviations from the raw dataset.
###
### Pre-requisites
### - The R code was developed and tested on "R version 3.1.2 (2014-10-31)" on Max OS X 10.9, it has not been tested on any other configuration
### - The working directory needs to set to the root of the "UCI HAR Dataset"
###
### How to run
### 1. Start R
### 2. Set working directory to the root of the "UCI HAR Dataset"
### 3. Source the run_analysis.R script###
###
### Input
### - The "UCI HAR Dataset" with the following directory structure
###     activitiy_labels.txt
###     features.txt
###     train/
###        subject_text.txt
###        X_test.txt
###        y_test.txt
###     test/
###        subject_train.txt
###        X_train.txt
###        y_train.txt
###
### Output
### - A file named "tidy_df.txt" containting the tidy dataset will be created in the working directory
### - The file format is space-separated with quoted character vectors
### - The file has a header row describing the columns
###
### Logic
### 1. Load reference data (activity_labels.txt and features.txt)
### 2. Load and label test data set (subject_text.txt, X_test.txt and y_test.txt)
###    - Feature labels based on features.txt
### 3. Merge test data set into one dataframe
### 4. Load and label training data set (subject_text.txt, X_test.txt and y_test.txt)
###    - Feature labels based on features.txt
### 5. Merge training data set into one dataframe
### 6. Merge test and training data sets
### 7. Label activities based on activity_labels.txt
### 8. Filter features to keep only mean and SD measurements
### 9. Create tidy dataframe by calculating mean of all features by subject and activity
### 10. Prepend feature names with "mean_" to indicate that they are mean values
### 11. Remove "()" and replace "-" with "_" in feature names to make them valid for R use
### 12. Store tidy dataframe in "tidy_df.txt" file in working directory
###

##
## Load reference data
##

# Get feature labels
features_df<-read.delim(file="features.txt", sep = "", header=F)
# Get activity labels
activity_labels_df<-read.delim(file="activity_labels.txt", sep = "", header=F)

##
## Ingest test data set
##

# Get subjects and label data
test_subject_df<-read.delim(file="test/subject_test.txt", sep="", header=F)
names(test_subject_df)<-c("subject_id")
# Get activity Ids and label data
test_activity_df<-read.delim(file="test/y_test.txt", sep = "", header=F)
names(test_activity_df)<-c("activity")
# Get feature values and label data
test_values_df<-read.delim(file="test/X_test.txt", sep = "",header=F)
names(test_values_df)<-features_df$V2
# Bind columns (subject, activity, feature values)
test_df<-cbind(test_subject_df, test_activity_df, test_values_df)

##
## Ingest training data set
##

# Get subjects and label data
train_subject_df<-read.delim(file="train/subject_train.txt", sep="", header=F)
names(train_subject_df)<-c("subject_id")
# Get activities and label data
train_activity_df<-read.delim(file="train/y_train.txt", sep="", header=F)
names(train_activity_df)<-c("activity")
# Get feature values and label data
train_values_df<-read.delim(file="train/X_train.txt", sep="",header=F)
names(train_values_df)<-features_df$V2
# Bind columns (subjects, activity, feature values)
train_df<-cbind(train_subject_df, train_activity_df, train_values_df)

##
## Prepare complete data set
##

# Merge test and training data sets
complete_df<-rbind(test_df, train_df)
# Set activity factors
complete_df$activity <- factor(complete_df$activity, levels=activity_labels_df$V1, labels=activity_labels_df$V2)
# Filter unwanted columns
# Keep columns subject_id, activity and any columns ending in "mean()" or "std()"
complete_df <- complete_df[,grep("subject_id|activity|mean\\(\\)|std\\(\\)", names(complete_df), value = T)]


##
## Create tidy dataset
##

# Create a new tidy dataframe that contains the mean for all features by subject_id and activity
tidy_df <- aggregate(. ~ subject_id + activity, data=complete_df, mean)
# Rename features by prepending "mean_" to indicate that all measurements are a mean value
names(tidy_df) <- ifelse(names(tidy_df) %in% c("subject_id", "activity"),
                         names(tidy_df),
                         gsub("(.*)", "mean_\\1", names(tidy_df)))
# Remove parenthesis and replace "-" with "_" to make the column names valid for R use
names(tidy_df) <- gsub("\\(\\)", "", names(tidy_df))
names(tidy_df) <- gsub("\\-", "\\_", names(tidy_df))

# Write tidy dataset to disk
# The file will contain column headers but now row names
write.table(tidy_df, file = "tidy_df.txt", row.names=F)

