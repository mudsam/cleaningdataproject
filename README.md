#run_analysis.R

##Purpose
 - Merge, label and summarize the "UCI HAR Dataset"
 - See CodeBook for details on input and output data

##Pre-requisites
 - The R code was developed and tested on "R version 3.1.2 (2014-10-31)"
 - The working directory needs to set to the root of the "UCI HAR Dataset"

##Input
 - The "UCI HAR Dataset" with the following directory structure
     activitiy_labels.txt
     features.txt
     train/
        subject_text.txt
        X_test.txt
        y_test.txt
     test/
        subject_train.txt
        X_train.txt
        y_train.txt

##Output
 - A file named "tidy_df.txt" containting the tidy dataset will be created in the working directory
 - The file format is space-separated with quoted character vectors
 - The file has a header row describing the columns

##Logic
1. Load reference data (activity_labels.txt and features.txt)
2. Load and label test data set (subject_text.txt, X_test.txt and y_test.txt)
    - Feature labels based on features.txt
3. Merge test data set into one dataframe
4. Load and label training data set (subject_text.txt, X_test.txt and y_test.txt)
    - Feature labels based on features.txt
5. Merge training data set into one dataframe
6. Merge test and training data sets
7. Label activities based on activity_labels.txt
8. Filter features to keep only mean and SD measurements
    - Keep feature names ending in "mean()"" or "sd()""
9. Create tidy dataframe by calculating mean of all features by subject and activity
10. Prepend feature names with "mean_" to indicate that they are mean values
11. Remove "()" and replace "-" with "_" in feature names to make them valid for R use
12. Store tidy dataframe in "tidy_df.txt" file in working directory
