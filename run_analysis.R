# 1 - Merge training and test sets to create one data set
## initial data load
xtest <- read.table("x_test.txt", header = FALSE)
xtrain <- read.table("x_train.txt", header = FALSE)
ytest <- read.table("y_test.txt", header = FALSE)
ytrain <- read.table("y_train.txt", header = FALSE)
subject.test <- read.table("subject_test.txt", header = FALSE)
subject.train <- read.table("subject_train.txt", header = FALSE)
features <- read.table("features.txt", header = FALSE)

## combine x sets and label columns
xdata <- rbind(xtest,xtrain)
colnames(xdata) <- features$V2

## combine subjects and activity labels, label appropriately
subjects <- rbind(subject.test,subject.train)
colnames(subjects) <- c("subject")
activities <- rbind(ytest,ytrain)
colnames(activities) <- c("activity")

## combine all data sets
wearable <- cbind(subjects,activities,xdata)

# 2 - Extract the measurements on mean and standard deviation
sub.features <- read.csv("features.csv", header = TRUE)
columns <- as.vector(sub.features$Columns)
wearable2 <- wearable[ ,columns]

# 3 - Use descriptive activity names in place of numbers
wearable3 <- mutate(wearable2, activity = factor(activity))
wearable3 <- wearable3 %>% mutate(activity = revalue(activity, 
                        c("1" = "WALKING", "2" = "UPSTAIRS", "3" = "DOWNSTAIRS",
                          "4" = "SITTING", "5" = "STANDING", "6" = "LAYING")))

# 5 - Create a second data set with the average of each variable by activity subject
wearable4 <- mutate(wearable3, subject = factor(subject))
summary <- wearable4 %>% group_by(subject, activity) %>% summarize_each(funs(mean))                                                                

# submission steps
## write text file of primary tidy data set
write.table(wearable4,"wearablefinal.txt",row.names = FALSE)







