setwd("~/assignments/assignment3-dc/UCI HAR Dataset/")

##
## Load reference data
##

# Get feature labels
features_df<-read.delim(file="features.txt",sep = "", header=F)
# Get activity labels
activity_labels_df<-read.delim(file="activity_labels.txt", sep = "", header=F)

##
## Ingest test data set
##

# Get subjects and set label
test_subject_df<-read.delim(file="test/subject_test.txt", sep="", header=F)
names(test_subject_df)<-c("subject_id")
# Get activity Ids and set label
test_activity_df<-read.delim(file="test/y_test.txt", sep = "", header=F)
names(test_activity_df)<-c("activity")
# Get feature values and set labels
test_values_df<-read.delim(file="test/X_test.txt",sep = "",header=F)
names(test_values_df)<-features_df$V2
# Bind columns (subject, activity, feature values)
test_df<-cbind(test_subject_df, test_activity_df, test_values_df)

##
## Ingest training data set
##

# Get  subjects Ids and set label
train_subject_df<-read.delim(file="train/subject_train.txt", sep="", header=F)
names(train_subject_df)<-c("subject_id")
# Get activity Ids and set label
train_activity_df<-read.delim(file="train/y_train.txt", sep = "", header=F)
names(train_activity_df)<-c("activity")
# Get feature values and set labels
train_values_df<-read.delim(file="train/X_train.txt", sep = "",header=F)
names(train_values_df)<-features_df$V2
# Bind columns (subjects, activity, feature values)
train_df<-cbind(train_subject_df,train_activity_df,train_values_df)

##
## Prepare complete data set
##

# Merge test and training data sets
complete_df<-rbind(test_df, train_df)
# Set activity factors
complete_df$activity <- factor(complete_df$activity, levels = activity_labels_df$V1, labels = activity_labels_df$V2)
# Filter unwanted columns
# Keep columns subject_id, activity and any columns ending in "mean()" or "std()"
complete_df <- complete_df[,grep("subject_id|activity|mean\\(\\)|std\\(\\)", names(complete_df), value = T)]

