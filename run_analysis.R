#install.packages("data.table")
library(data.table)

# Setup the files
download.file(url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              destfile = "dados.zip", method = "wget")
unzip("dados.zip")
#Change Directory
setwd('UCI HAR Dataset/')

#Features
features.data <- read.table('features.txt', col.names = c('index', 'name'))
features <- subset(features.data, grepl('-(mean|std)[(]', features.data$name))
#Labels
label.setnames <- read.table('activity_labels.txt', col.names = c('level', 'label'))

#Train Data
data.train <- read.table("train/X_train.txt")[, features$index]
names(data.train) <- features$name
label.set.train <- read.table("train/y_train.txt")[, 1]
data.train$label <- factor(label.set.train, levels=label.setnames$level, labels=label.setnames$label)
subject.set.train <- read.table("train/subject_train.txt")[, 1]
data.train$subject <- factor(subject.set.train)
train.set<-data.table(data.train)

#Test Data
data.test <- read.table("test/X_test.txt")[, features$index]
names(data.test) <- features$name
label.set.test <- read.table("test/y_test.txt")[, 1]
data.test$label <- factor(label.set.test, levels=label.setnames$level, labels=label.setnames$label)
subject.set.test <- read.table("test/subject_test.txt")[, 1]
data.test$subject <- factor(subject.set.test)
test.set<-data.table(data.test)

#Bind everything
colnames(train.set)
colnames(test.set)
dataset <- rbind(train.set, test.set)

#Tidy data
tidy.dataset <- dataset[, lapply(.SD, mean), by=list(label, subject)]

#change varibles names
names <- names(tidy.dataset)
names <- gsub('-mean', ' Mean ', names)
names <- gsub('-std', ' Std ', names)
names <- gsub('[()-]', '', names)
names <- gsub('BodyBody', 'Body', names)

setnames(tidy.dataset, names)

#Write the result on a file
colnames(tidy.dataset)
setwd('..')
write.csv(dataset, file = 'rawdata.csv', row.names = FALSE)
write.csv(tidy.dataset, file = 'tidydata.csv',row.names = FALSE, quote = FALSE)

