run_analysis <- function(){
    if (!file.exists('UCI HAR Dataset')){
        stop('Data files not found. Please download archive from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip into the current folder, uncompress it and try again')
    }
    # Load the data sets
    cat('Loading X_train data...')
    X_train <- read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
    print('Done')
    cat('Loading X_test data...')
    X_test <- read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
    print('Done')
    cat('Loading y_train data...')
    y_train <- read.csv("UCI HAR Dataset/train/y_train.txt", sep="", header=FALSE)
    print('Done')
    cat('Loading y_test data...')
    y_test <- read.csv("UCI HAR Dataset/test/y_test.txt", sep="", header=FALSE)
    print('Done')
    cat('Loading subject_train data...')
    subject_train <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)
    print('Done')
    cat('Loading subject_test data...')
    subject_test <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)
    print('Done')

    # 1. Merge the training and the test sets to create one data set (but we still keep activity and subject separated from the observation data)
    cat('Mergint train and test datasets...')
    X <- rbind(X_train, X_test)
    y <- rbind(y_train, y_test)
    subject <- rbind(subject_train, subject_test)
    print('Done')

    # 2. Extract only the measurements on the mean and standard deviation for each measurement.
    cat('Removing unwanted columns...')
    features <- as.character(read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)[,2])
    mean_std_columns <- grep("[mM]ean|std", features)
    X <- X[,mean_std_columns]
    print('Done')

    # 3. Use descriptive activity names to name the activities in the data set
    cat('Converting activity ids into corresponding names...')
    activity_labels <- read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)
    y$activity_name <- activity_labels[y$V1,2]
    print('Done')

    # 4. Appropriately label the data set with descriptive variable names (we use the feature names) 
    cat('Labeling columnns with descriptive names...')
    names(X) <- features[mean_std_columns]
    names(subject)[1] <- "subject"
    print('Done')

    # 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
    cat('Aggregating data by activity name and subject...')
    tidy_data <- aggregate(X, by=list(activity=y$activity_name, subject=subject$subject), mean)
    write.table(tidy_data, "tidy_data.txt", sep=" ", row.name=FALSE)
    print('Done')
}
