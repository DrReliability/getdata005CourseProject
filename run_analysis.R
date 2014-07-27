## run_analysis.R - Project assignment for the Coursera course "Getting & Cleaning Data"
## by Kelvin Chu 
## created     : 07/10/2014
## last updated: 07/25/2014
#  ====================================================================================== 
# change default directory to the working directory
setwd("C:/ZKelvin/50 Professional/80 Technical Info/01 Data Science/Courses/01 Coursera Data Science Course/03 Getting & Cleaning Data/Assignments/UCI HAR Dataset")
getwd()   # check to make sure
# Definition:
# x.train, x.test, x       - training and testing data for the measured & calculated data (1-561)
# y.train, y.test, y       - training and testing data for the activities of each 
#                            corresponding measurement (1-6)
# sub.train, sub.test, sub - training and testing data for the subject of each corresponding
#                            measurement (1-30)
# x.select                 - training and testing data containing only the mean and standard 
#                            deviation for each measurement (the remaining data are excluded)
# features                 - labels for each measurement (1-561)
# activity                 - labels for each activity (1-6)

# Output datasets:
# xysub.tidy               - single tidy dataset combining training and testing data of subjects,
#                            activities and only mean and standard deviation of each measurement
# xysub.mean               - second, independent tidy data set with the average of each variable
#                            for each subject and each variable (based on the tidy dataset above)

# Step 0 - Read data from input datasets
x.train   <- read.table("./train/X_train.txt", header=FALSE)	
y.train   <- read.table("./train/y_train.txt", header=FALSE)
x.test    <- read.table("./test/X_test.txt", header=FALSE)
y.test    <- read.table("./test/y_test.txt", header=FALSE)
sub.train <- read.table("./train/subject_train.txt", header=FALSE)
sub.test  <- read.table("./test/subject_test.txt", header=FALSE)
features  <- read.table("features.txt", header=FALSE)
activity  <- read.table("activity_labels.txt", header=FALSE)

# Step 1 - Merge the training and the test datasets 
#        - append the testing dataset to the training dataset to create 
#          one data set 
#        - make sure the order is the same for x, y and sub
x   <- rbind(x.train, x.test)
y   <- rbind(y.train, y.test)
sub <- rbind(sub.train, sub.test)

# Step 2 - appropriately labels the data set with descriptive variable names. 
#          This was done ahead of step 2 for easier data extraction later
#   step 2a - eliminate index in features, just the names
features   <- as.matrix(features[,-1])
#   step 2b - eliminate index in features, just the names
names(x)   <- features
names(y)   <- "activity"
names(sub) <- "subject"

# Step 3 - Extracts only the measurements on the mean and standard deviation for each 
#          measurement, i.e. only names with the substring mean, or std
x.select <- cbind(x[,grep("_mean",names(x))],x[,grep("_std",names(x))])

# Step 4 - Uses descriptive activity names to name the activities in the data set
y[,1] <- activity[y[,1],2]

# Step 5 - putting everything together 
xysub.tidy <- cbind(sub, y, x.select)

# Step 6 - Create a second, independent tidy data set with the average of each variable 
#          for each activity and each subject
#        - the resulting new data frame needs to be sorted by 'subject' and then 'activity'
xysub.mean <- aggregate(xysub.tidy[,-c(1:2)], 
              by=list(subject=xysub.tidy$subject,activity=xysub.tidy$activity),mean)
#        - sort data set by subject and then activity
xysub.mean <- xysub.mean[with(xysub.mean,order(subject,activity)),]
#        - sort data set by activity and then subject
xysub.mean <- xysub.mean[with(xysub.mean,order(activity,subject)),]

# Step 7 - Save both dataset to space-delimited text files
write.table(xysub.tidy, "./measurement_tidy.txt", sep=" ", row.name=FALSE)
write.table(xysub.mean, "./mean_measurement_tidy.txt", sep= " ", row.name=FALSE)









