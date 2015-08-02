Xtrain <- read.table("./data/UCIHARDataset/train/X_train.txt")
Xtest <- read.table("./data/UCIHARDataset/test/X_test.txt")
X <- rbind(Xtrain, Xtest)
Subtrain <- read.table("./data/UCIHARDataset/train/subject_train.txt")
Subtest <- read.table("./data/UCIHARDataset/test/subject_test.txt")
s <- rbind(Subtrain, Subtest)
Ytrain <- read.table("./data/UCIHARDataset/train/Y_train.txt")
Ytest <- read.table("./data/UCIHARDataset/test/Y_test.txt")
Y <- rbind(Ytrain, Ytest)
feature <- read.table("./data/UCIHARDataset/features.txt")
gdfeaturesIndices <- grep("-mean\\(\\)|-std\\(\\)", feature[, 2])
X <- X[, gdfeaturesIndices]
names(X) <- feature[gdfeaturesIndices, 2]
names(X) <- gsub("\\(|\\)", "", names(X))
names(X) <- tolower(names(X))
activities <- read.table("./data/UCIHARDataset/activity_labels.txt")
activities[, 2] = gsub("_", "", tolower(as.character(activities[, 2])))
Y[,1] = activities[Y[,1], 2]
names(Y) <- "activity"
names(s) <- "subject"
cleaned <- cbind(s, Y, X)
write.table(cleaned, "./data/merged_clean_data.txt")

uniqueSubjects = unique(s)[,1]
numSubjects = length(unique(s)[,1])
numActivities = length(activities[,1])
numCols = dim(cleaned)[2]
result = cleaned[1:(numSubjects*numActivities), ]

row = 1
for (sbj in 1:numSubjects) {
  for (actv in 1:numActivities) {
    result[row, 1] = uniqueSubjects[sbj]
    result[row, 2] = activities[actv, 2]
    tmp <- cleaned[cleaned$subject==sbj & cleaned$activity==activities[actv, 2], ]
    result[row, 3:numCols] <- colMeans(tmp[, 3:numCols])
    row = row+1
  }
}

write.table(result, "./data/data_set_with_the_averages.txt")