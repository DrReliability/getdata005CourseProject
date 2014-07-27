---
title: "Getting and Cleaning Data"  
output author: "Chi Hung Kelvin Chu"
output date: "Thursday, July 24, 2014"
output: html_document
runtime: shiny
---
##Course Project

The purpose of this course project is to demonstrate the ability to collect, work with and clean a data set. This document describes in detail how and what were done to the given input data set to produce the final tidy data set required in the assignment.

###Data source 
The data for this course assignment was downloaded from the following given url:

download [Data for the Course Project](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) here.

###Description of the data
**Measurement taken:**  

|      Description         | Range 
|--------------------------|--------------------------------------------------------|
|Number of subjects        |: 30                                                    |
|Age range                 |: 19-48 year                                            |
|Number of activities      |: 6 per person                                          |
|Measurement taken         |: X-, Y-, Z-axial linear acceleration & angular velocity|  
|                          |                                                        |

Both measurements are measured for the 3-axis.  The acceleration signal is further separated into gravitational and body motion components.  A number of variables are then calcuated for the time and frequency domain.  

A full listing of the variables and an explanation of variables are provided in the code book.  

**Data provided for each record :** 

* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.  
* Triaxial Angular velocity from the gyroscope.  
* A 561-feature vector with time and frequency domain variables.
* Its activity label.  
* An identifier of the subject who carried out the experiment.  

###Description of the variables
**Input Measurement Variables**  
The following describes the naming convention used for the input measurement.  A detail list of all the measurement variables is provided in the code book.  Several different types of signals were obtained and recorded ('_XYZ' denote 3-axial signals in the X, Y and Z directions):  
  
**Feature variables**  

* Raw accelerometer and gyroscope 3-axial signals at regular time intervals  
    + time_ACC_XYZ
    + time_Gyro_XYZ
* Body & gravity signals - 3-axial signals obtained from the accelerometer signals using low pass Butterworth filter  
    + time_BodyACC_XYZ
    + time_GravityACC_XYZ
* Body & angular Jerk signals - 3-axial signals derived from the accelerometer & gyro signals  
    + time_BodyACCJerk_XYZ
    + time_BodyGyroJerk_XYZ
* Magnitudes of accelerometer, gyro & gravity signals - magnitude of the signals calculated from the respective 3-axial signals
    + time_BodyACCMag
    + time_BodyGravityAccMag
    + time_BodyACCJerkMag
    + time_BodyGyroMag
    + time_BodyGyroJerkMag  
* Frequency signals - Fast Fourier Transform (FFT) was applied to some of the signals above to produce similar signals in the frequency domain
    + freq_BodyACC_XYZ
    + freq_BodyACCJer_XYZ
    + freq_BodyACCJerkMag
    + freq_BodyGyro_XYZ
    + freq_BodyGyroMag
    + freq_BodyGyroJerkMag  
   
These signals were used to estimate variables of the feature vector for each pattern.  The set of variables that were estimated from these signals were:  

|    Functions    |  Descriptions                                                              |
|-----------------|----------------------------------------------------------------------------|
| * mean():       | Mean value  |
| * std():        | Standard deviation  |
| * mad(): | Median absolute deviation   |
| * max(): | Largest value in array  |
| * min(): | Smallest value in array  |
| * sma(): | Signal magnitude area  |
| * energy(): | Energy measure. Sum of the squares divided by the number of values.  |
| * iqr(): | Interquartile range  |
| * entropy(): | Signal entropy  |
| * arCoeff(): | Autorregresion coefficients with Burg order equal to 4  |
| * correlation(): | correlation coefficient between two signals  |
| * maxInds(): | index of the frequency component with largest magnitude  |
| * meanFreq(): | Weighted average of the frequency components to obtain a mean frequency  |
| * skewness(): | skewness of the frequency domain signal  |
| * kurtosis(): | kurtosis of the frequency domain signal  |
| * bandsEnergy(): | Energy of a frequency interval within the 64 bins of the FFT of each window.  |
| * angle(): | Angle between two vectors.   |
|            |                                 |

Additional vectors were obtained by averaging the signals in a signal window sample.  These are used on the angle() variable:  

* gravityMean  
* time_BodyAccMean  
* time_BodyAccJerkMean  
* time_BodyGyroMean  
* time_BodyGyroJerkMean  

**Activity variables**  
Six (6) activity types were defined for this measurement experiment.  These are:  

1. WALKING
2. WALKING_UPSTAIRS
3. WALKING_DOWNSTAIRS
4. SITTING
5. STANDING
6. LAYING  

**Subject variable**  
Thirty (30) volunteers were involved in this experiment.  They were labeled as 1 to 30.

**Variables used in the R script**  
The following variables were used in the R script:  

* **x.train, x.test, x**       - training and testing data for the measured & calculated data (1-561)  
* **y.train, y.test, y**       - training and testing data for the activities of each corresponding measurement (1-6)  
* **sub.train, sub.test, sub** - training and testing data for the subject of each corresponding measurement (1-30)  
* **x.select**                 - training and testing data for the mean and standard deviation measurements (the remaining data are excluded)  
* **features**                 - labels for each measurement (1-561)  
* **activity**                 - labels for each activity (1-6)  
  
Output datasets:  

* **xysub.tidy**               - single tidy dataset combining training and testing data of subjects, activities and only mean and standard deviation of each measurement  
* **xysub.mean**               - second, independent tidy data set with the average of each variable for each subject and each variable (based on the tidy dataset above)  

###The Deliverable
This course requires the student to create an independent tidy data set with the average of each variable for each activity and each subject (the second data set described in the guideline).  This document describes the process of obtaining this tidy data set from the input data given by the instructor.

A R script which generates this tidy data set, README markdown file (this document, READ.md) and a code book (CourseProject_Codebook.txt) explaining the variables are available in the github repo directory submitted.  

###The Approach
The project guideline suggested a 5-step approach to come up with the tidy dataset that includes the average of each variable for each activity and each subject.  

After working with the data for a while, it makes a little bit more sense to the author to take the following steps instead of following the suggested sequence of steps, which will be explained in detail below:

* Step 0 - fix feature variable names using external text processor for easier identification
* Step 1 - read input data into R from input datasets
* Step 2 - combine the training and the test dataset into one dataset
* Step 3 - label the dataset with descriptive variable names for easier data extraction
* Step 4 - extract only the columns with the mean and standard deviation for each measurement
* Step 5 - replace the activity code with its corresponding activity name
* Step 6 - create the tidy data set for the resulting data set
* Step 7 - create the second tidy data set for the mean of each variable for each activity and subject
* Step 8 - save the resulting data set to a space-delimited text file with space (" ") separation 

**Step 0:**  

Rename the features' names to slightly more understandable names using a text processor outside of R.  Blobal "Find and Replace" of text is much easier to do using the text processor than using R function  This includes the following changes.  

* change the first letter of the features' variables from **"t"** and **"f"** to **"time_"** and **"freq_"** so that it is easier for the user to distinguish the features between time and frequency measurements  
* change all **"-"** to "_" so that it will not be confused as a mathematical symbol  
* change **"fBodyBody"** to **"freq_Body"**; the extra **"Body"** in the spelling is believed to be either typo or redundant  
* remove **"()"** from all the features' variables; these are probably functions to calculate the particular measurements, e.g. mean() is the function to calculate the mean of the measurement, and does not convey any extra meaning to the description of the variables  
* add axial direction to redundant names - names for these entries, 303-316, 317-330, 331-344, were redundant; these entries were obviously for the 3-axial measurements, therefore axial identifications were added back to these names.  Similarly operations are applied to entries 382-423 and 461-502.  although these columns of data will not be used in the final tidy data set (because they are not means and standard deviations), the labels were cleaned up to make sure that there are no confusion if one has to look at the original data set

**Step 1:**  

Read data into R (or RStudio) from the input datasets using the read.table command.  Although it is possible to create very few intermediate datasets to achieve what is required, different intermediate datasets were retained in this exercise so that after the final data set has been created, the user can examine all the intermediate steps to either verify the results for each step or to debug if something goes wrong.  In real practice, it is not necessary to retain all these intermediate datasets since they will not be reused in future analysis.

Eight inputs datasets were read into R representing the followings:

* two (2) 561-feature variable measurements - one for the training set, the other for the testing set - **"x.train"** & **"x.test"**
* two (2) 1 column data set providing the activity information (in numeric code) for each measurement and for the training and testing sets - **"y.train"** & **"y.test"**
* two (2) 1 column data set providing the subject information (in numeric code) for each measurement and for the training and testing sets - **"sub.train"** & **"sub.test"**
* one (1) 1 column data set providing the variable names for each feature (561 entries) - **"features"**
* one (1) 1 column data set providing the activity names (6 entries) - **"activity"**

The input data are read into R using the following R command:  
```
x.train   <- read.table("./train/X_train.txt", header=FALSE)    
y.train   <- read.table("./train/y_train.txt", header=FALSE)
x.test    <- read.table("./test/X_test.txt", header=FALSE)
y.test    <- read.table("./test/y_test.txt", header=FALSE)
sub.train <- read.table("./train/subject_train.txt", header=FALSE)
sub.test  <- read.table("./test/subject_test.txt", header=FALSE)
features  <- read.table("features.txt", header=FALSE)
activity  <- read.table("activity_labels.txt", header=FALSE)
dim(x.train)
```
```
[1] 7352  561
```

**Step 2:**  

The training and the testing data should be combined into one single dataset first to avoid repeating similar opearations on these two sets of data.  It will also help to maintain the correct sequence of the data in case some R operation may change the order of the data.

As noted previously, the use of separate intermediate datasets are not necessary, but was done for this exercise just to ensure that they are available for examination later on.  The testing and training data were combined using the rbind command.

Three intermediate datasets are created in these steps, namely **x**, **y**, & **sub**.  
```
x   <- rbind(x.train, x.test)  
y   <- rbind(y.train, y.test)  
sub <- rbind(sub.train, sub.test)  
dim(x)
```
```
[1] 10299   561
```
```
dim(y)
```
```
[1] 10299     1
```
```
dim(sub)
```
```
[1] 10299     1
```

**Step 3:**  

After combining the training and testing data, the column names of the combined dataset, x, y and sub are labeled as "V1", "V2" ..., these should be replaced with the appropriate labels using the data sets that was imported in step 1.  

Since the data sets are currently synchronized with each other, that is the measurement data columns are in the right sequence as the feature listed in the feature data set, there is no need to retain the index column in the feature dataset and the remaining data frame (1 column) was converted to a vector.

The column names of the measurement data sets was renamed using information read in from the feature data, and the remaining two columns names were replaced by their respective data names, "activity" and "subject".  These were achieved using the following R Commands:
```
features   <- as.matrix(features[,-1])  # eliminate the index column  
names(x)[1:5]                           # first 5 column names before renaming  
```
```
[1] "V1" "V2" "V3" "V4" "V5"
```

```
names(x)   <- features                  # replace column names of x with features  
names(y)   <- "activity"                # replace column names of y with "activity"  
names(sub) <- "subject"                 # replace column names of y with "subject"  
names(x)[1:5]                           # first 5 column names after renaming
```
```
[1] "time_BodyAcc_mean_X" "time_BodyAcc_mean_Y" "time_BodyAcc_mean_Z"
[4] "time_BodyAcc_std_X"  "time_BodyAcc_std_Y"
```

**Step 4:**  

The project assignment requires only the mean and standard deviation of the measurements be used in the tidy data set.  The next step then extracts only these measurements from the full data set.

It is assumed that only measurements with names including mean() and std() are the average and standard deviation of the measurements.  Practically the mean and standard deviation measure of the time and frequency can be clearly identified by looking for substrings of **"_mean"** and **"_std"**.  

However, some people may wonder whether the 7 angle measurements which include the mean value of the gravity as the inputs should also be included in the final tidy dataset or not.  A decision was made to eliminate these measurements from the final data set because they only used the mean value of the Gravity measurement and they themselves were not calculated as a mean value.  

The subsetted data set was obtained using R's grep function and combine the columns which are the mean and standard deviation of the measurements as following.  
One can check the data set before and after to verfity if the correct number of columns have been selected, i.e. **dim(x)** & ** dim(x.select)**.  the results indicated that the original data set was reduced from [10299, 561] down to [10299, 79].  
```
dim(x)
```
```
[1] 10299   561
```
```
x.select <- cbind(x[,grep("mean",names(x))],x[,grep("std",names(x))])
dim(x.select)
```
```
[1] 10299    79
```

**Step 5:**  

The activity column, up to this point, uses activity code to represent the activity of the subject during the measurement.  These codes were replaced by their respecitve activity names from the activity data set using the following R command.  This command replaces the value of column 1 of each measurement in the activity data set with the corresponding names from the original input activity data set
```
y[c(1,28,52,79,126,152),]
```
```
[1] 5 4 6 1 3 2
```
```
y[,1] <- activity[y[,1],2]
y[c(1,28,52,79,126,152),]
```
```
[1] STANDING           SITTING            LAYING            
[4] WALKING            WALKING_DOWNSTAIRS WALKING_UPSTAIRS  
6 Levels: LAYING SITTING STANDING WALKING ... WALKING_UPSTAIRS  
```

**Step 6:**  

Finally the subject, activity and mean and standard deviation of the feature measurements were combined together to form the first tidy data set.  
```
xysub.tidy <- cbind(sub, y, x.select)
dim(xysub.tidy)
```
```
[1] 10299    81
```
```
head(xysub.tidy[,1:4], n=3)
```
```
  subject activity time_BodyAcc_mean_X time_BodyAcc_mean_Y
1       1 STANDING              0.2886            -0.02029
2       1 STANDING              0.2784            -0.01641
3       1 STANDING              0.2797            -0.01947
```

**Step 7:**  

The second, independent tidy data set was created using the aggregate and order commands.

* create a second, independent tidy data set with the average (mean) of each variable for each activity and each subject
* the resulting new data frame needed to be sorted by 'subject' and then 'activity'  

```
xysub.mean <- aggregate(xysub.tidy[,-c(1:2)],  
              by=list(subject=xysub.tidy$subject,activity=xysub.tidy$activity),mean)
xysub.mean <- xysub.mean[with(xysub.mean,order(subject,activity)),]
head(xysub.mean[,1:4],n=12)
```
```
    subject           activity time_BodyAcc_mean_X time_BodyAcc_mean_Y
1         1             LAYING           0.2215982        -0.040513953
31        1            SITTING           0.2612376        -0.001308288
61        1           STANDING           0.2789176        -0.016137590
91        1            WALKING           0.2773308        -0.017383819
121       1 WALKING_DOWNSTAIRS           0.2891883        -0.009918505
151       1   WALKING_UPSTAIRS           0.2554617        -0.023953149
2         2             LAYING           0.2813734        -0.018158740
32        2            SITTING           0.2770874        -0.015687994
62        2           STANDING           0.2779115        -0.018420827
92        2            WALKING           0.2764266        -0.018594920
122       2 WALKING_DOWNSTAIRS           0.2776153        -0.022661416
152       2   WALKING_UPSTAIRS           0.2471648        -0.021412113
```

**Step 8:**  

The second, independent tidy data set was saved as a text file to be uploaded to Coursera.  To eliminate the row numbers, 'row.name=False' is specified when writing to the text file.  Otherwise, the row numbers would aslo be written to the file, which is undersirable.

```
write.table(xysub.mean, "./mean_measurement_tidy.txt", sep= " ", row.name=FALSE)
```
