#Data Ingestion

A <- read.csv('/Users/shashankkumar/Studies/SecondSem/ML/Assignments/Assignment2/Dataset/BlogFeedback/blogData_train.csv',header=FALSE,sep=",",)
B <- read.csv('/Users/shashankkumar/Studies/SecondSem/ML/Assignments/Assignment2/Dataset/BlogFeedback/blogData_test-2012.02.01.00_00.csv',header=FALSE,sep=",",)
C <- read.csv('/Users/shashankkumar/Studies/SecondSem/ML/Assignments/Assignment2/Dataset/BlogFeedback/blogData_test-2012.02.02.00_00.csv',header=FALSE,sep=",",)
D <- read.csv('/Users/shashankkumar/Studies/SecondSem/ML/Assignments/Assignment2/Dataset/BlogFeedback/blogData_test-2012.03.01.00_00.csv',header=FALSE,sep=",",)
E <- read.csv('/Users/shashankkumar/Studies/SecondSem/ML/Assignments/Assignment2/Dataset/BlogFeedback/blogData_test-2012.03.02.00_00.csv',header=FALSE,sep=",",)

#Data Preparation for Experiment 1 and 2
#Setting the column names across the datasets

for(i in 1:281){names(A)[ncol(A)] <- paste0("V", i)}
for(i in 1:281){names(B)[ncol(B)] <- paste0("V", i)}
for(i in 1:281){names(C)[ncol(C)] <- paste0("V", i)}
for(i in 1:281){names(D)[ncol(D)] <- paste0("V", i)}
for(i in 1:281){names(E)[ncol(E)] <- paste0("V", i)}

#Data Preprocessing

testSet_Exp1_Feb1 <- B[c("V51","V52","V53","V54","V55","V56","V57","V58","V59","V60")]
testSet_Exp1_Feb2 <- C[c("V51","V52","V53","V54","V55","V56","V57","V58","V59","V60")]
testSet_Exp1_Mar1 <- D[c("V51","V52","V53","V54","V55","V56","V57","V58","V59","V60")]
testSet_Exp1_Mar2 <- E[c("V51","V52","V53","V54","V55","V56","V57","V58","V59","V60")]
testSet_Exp2_Feb1 <- B[63:262]
testSet_Exp2_Feb2 <- C[63:262]
testSet_Exp2_Mar1 <- D[63:262]
testSet_Exp2_Mar2 <- E[63:262]
Actual_Exp1_Feb1 <- B[281]
Actual_Exp1_Feb2 <- C[281]
Actual_Exp1_Mar1 <- D[281]
Actual_Exp1_Mar2 <- E[281]
target<-A[281]

basic_feature<-A[c("V51","V52","V53","V54","V55","V56","V57","V58","V59","V60")]
basic_feature$V281<-target$V281

#Experiment 1
#Model 1-Linear Regression Model

LinearRegression_Model_Exp1 <- lm(formula=V281~V51+V52+V53+V54+V55+V56+V57+V58+V59+V60,data=basic_feature)

summary(LinearRegression_Model_Exp1)

#Problem of muliticolinearity
"V55 and V60 features are not defined because of singularities. Two or more of the independent variables are perfectly collinear. If we look closely at the dataset description, both these columns have been derived from other columns(52 & 53) and (57 & 58) from the dataset.

The basic assumption while creating Machine Learning models is explainatory variables or features are independent of each other. If they are are dependent, it brings in the problem of multicolinearity. Multicolinearity:

can make choosing the correct features to include more difficult
interferes in determining the precise effect of each feature
However, it does not affect the fit of the model overall.

Let us ponder over what can be done to remove multicolinearity. We have several options:

removing highly correlated features
combine correlated features
use other methods like principal components analysis(PCA) and partial least squares regression
For the problem at hand we will pick up the strategy to remove the highly correlated features out of our prediction model. Let us start by removing V55 and V60."

#Running Linear Model without features V55 and V60

testSet_Exp1_Feb1 <- B[c("V51","V52","V53","V54","V56","V57","V58","V59")]
testSet_Exp1_Feb2 <- C[c("V51","V52","V53","V54","V56","V57","V58","V59")]
testSet_Exp1_Mar1 <- D[c("V51","V52","V53","V54","V56","V57","V58","V59")]
testSet_Exp1_Mar2 <- E[c("V51","V52","V53","V54","V56","V57","V58","V59")]

basic_feature<-A[c("V51","V52","V53","V54","V56","V57","V58","V59")]
basic_feature$V281<-target$V281

LinearRegression_Model_Exp1 <- lm(formula=V281~V51+V52+V53+V54+V56+V57+V58+V59,data=basic_feature)

summary(LinearRegression_Model_Exp1)
"Multiple R-squared states that our explainatory variables are capable of explaning only 22.55% of the target variable. Not a good model indeed! We need to dig deeper to find out what went wrong."

# Correlation Matrix

cormat <- round(cor(basic_feature),2)
cormat

# Error metric (rss)

#We have choosen our error metric as rss.

Lin_pred_onTrain<-predict(LinearRegression_Model_Exp1,basic_feature,se.fit=TRUE)
rss=sum((target-Lin_pred_onTrain$fit)^2)
print(paste0("rss on training data is ", rss))

Lin_pred_exp1_Feb1<-predict(LinearRegression_Model_Exp1,testSet_Exp1_Feb1,se.fit=TRUE)
rss=sum((Actual_Exp1_Feb1-Lin_pred_exp1_Feb1$fit)^2)
print(paste0("rss on Feb1 test data is ", rss))

Lin_pred_exp1_Feb2<-predict(LinearRegression_Model_Exp1,testSet_Exp1_Feb2,se.fit=TRUE)
rss=sum((Actual_Exp1_Feb2-Lin_pred_exp1_Feb1$fit)^2)
print(paste0("rss on Feb2 test data is ", rss))

Lin_pred_exp1_Mar1<-predict(LinearRegression_Model_Exp1,testSet_Exp1_Mar1,se.fit=TRUE)
rss=sum((Actual_Exp1_Mar1-Lin_pred_exp1_Feb1$fit)^2)
print(paste0("rss on Mar1 test data is ", rss))

Lin_pred_exp1_Mar2<-predict(LinearRegression_Model_Exp1,testSet_Exp1_Mar2,se.fit=TRUE)
rss=sum((Actual_Exp1_Mar2-Lin_pred_exp1_Feb1$fit)^2)
print(paste0("rss on Mar2 test data is ", rss))

"Correlation matrix shows there are still many features strongly correlated. For instance, V56 & V59 and V51 & V54. Let us remove V59 & V54 and check performance of our model."

# Running Linear Model without features V59 and V54

testSet_Exp1_Feb1 <- B[c("V51","V52","V53","V56","V57","V58")]
testSet_Exp1_Feb2 <- C[c("V51","V52","V53","V56","V57","V58")]
testSet_Exp1_Mar1 <- D[c("V51","V52","V53","V56","V57","V58")]
testSet_Exp1_Mar2 <- E[c("V51","V52","V53","V56","V57","V58")]

basic_feature<-A[c("V51","V52","V53","V56","V57","V58")]
basic_feature$V281<-target$V281

LinearRegression_Model_Exp1 <- lm(formula=V281~V51+V52+V53+V56+V57+V58,data=basic_feature)
#summary(LinearRegression_Model_Exp1)

summary(LinearRegression_Model_Exp1)

Lin_pred_onTrain<-predict(LinearRegression_Model_Exp1,basic_feature,se.fit=TRUE)
rss=sum((target-Lin_pred_onTrain$fit)^2)
print(paste0("rss on training data is ", rss))

Lin_pred_exp1_Feb1<-predict(LinearRegression_Model_Exp1,testSet_Exp1_Feb1,se.fit=TRUE)
rss=sum((Actual_Exp1_Feb1-Lin_pred_exp1_Feb1$fit)^2)
print(paste0("rss on Feb1 test data is ", rss))

Lin_pred_exp1_Feb2<-predict(LinearRegression_Model_Exp1,testSet_Exp1_Feb2,se.fit=TRUE)
rss=sum((Actual_Exp1_Feb2-Lin_pred_exp1_Feb1$fit)^2)
print(paste0("rss on Feb2 test data is ", rss))

Lin_pred_exp1_Mar1<-predict(LinearRegression_Model_Exp1,testSet_Exp1_Mar1,se.fit=TRUE)
rss=sum((Actual_Exp1_Mar1-Lin_pred_exp1_Feb1$fit)^2)
print(paste0("rss on Mar1 test data is ", rss))

Lin_pred_exp1_Mar2<-predict(LinearRegression_Model_Exp1,testSet_Exp1_Mar2,se.fit=TRUE)
rss=sum((Actual_Exp1_Mar2-Lin_pred_exp1_Feb1$fit)^2)
print(paste0("rss on Mar2 test data is ", rss))
# Performance of our model does not change significantly after removing multicolinearity.

# Model 2-Logistic Regression
# Running Logistic Regression on the test datasets without columns V55 and V60

testSet_Exp1_Feb1 <- B[c("V51","V52","V53","V54","V56","V57","V58","V59")]
testSet_Exp1_Feb2 <- C[c("V51","V52","V53","V54","V56","V57","V58","V59")]
testSet_Exp1_Mar1 <- D[c("V51","V52","V53","V54","V56","V57","V58","V59")]
testSet_Exp1_Mar2 <- E[c("V51","V52","V53","V54","V56","V57","V58","V59")]

basic_feature<-A[c("V51","V52","V53","V54","V56","V57","V58","V59")]
basic_feature$V281<-target$V281



# Changing target variable to 0 and 1

basic_feature$V281<-ifelse(target$V281>0, 1,0)
target$V281<-ifelse(target$V281>0, 1,0)
Actual_Exp1_Feb1$V281<-ifelse(Actual_Exp1_Feb1$V281>0, 1,0)
Actual_Exp1_Feb2$V281<-ifelse(Actual_Exp1_Feb2$V281>0, 1,0)
Actual_Exp1_Mar1$V281<-ifelse(Actual_Exp1_Mar1$V281>0, 1,0)
Actual_Exp1_Mar2$V281<-ifelse(Actual_Exp1_Mar2$V281>0, 1,0)



LogisticRegression_Model_Exp1 <- glm(formula=V281~.,data=basic_feature,family = binomial(link = 'logit'))



summary(LogisticRegression_Model_Exp1)

Log_pred_onTrain<-predict(LogisticRegression_Model_Exp1,basic_feature,se.fit=TRUE)
rss=sum((target-Log_pred_onTrain$fit)^2)
print(paste0("rss on training data is ", rss))

Log_pred_exp1_Feb1<-predict(LogisticRegression_Model_Exp1,testSet_Exp1_Feb1,se.fit=TRUE)
rss=sum((Actual_Exp1_Feb1-Log_pred_exp1_Feb1$fit)^2)
print(paste0("rss on test Feb1 data is ", rss))

Log_pred_exp1_Feb2<-predict(LogisticRegression_Model_Exp1,testSet_Exp1_Feb2,se.fit=TRUE)
rss=sum((Actual_Exp1_Feb2-Log_pred_exp1_Feb2$fit)^2)
print(paste0("rss on test Feb2 data is ", rss))

Log_pred_exp1_Mar1<-predict(LogisticRegression_Model_Exp1,testSet_Exp1_Mar1,se.fit=TRUE)
rss=sum((Actual_Exp1_Mar1-Log_pred_exp1_Mar1$fit)^2)
print(paste0("rss on test Mar1 data is ", rss))

Log_pred_exp1_Mar2<-predict(LogisticRegression_Model_Exp1,testSet_Exp1_Mar2,se.fit=TRUE)
rss=sum((Actual_Exp1_Mar2-Log_pred_exp1_Mar2$fit)^2)
print(paste0("rss on test Mar2 data is ", rss))

#Running Logistic Model without features V59 and V54

testSet_Exp1_Feb1 <- B[c("V51","V52","V53","V56","V57","V58")]
testSet_Exp1_Feb2 <- C[c("V51","V52","V53","V56","V57","V58")]
testSet_Exp1_Mar1 <- D[c("V51","V52","V53","V56","V57","V58")]
testSet_Exp1_Mar2 <- E[c("V51","V52","V53","V56","V57","V58")]


basic_feature<-A[c("V51","V52","V53","V56","V57","V58")]
basic_feature$V281<-target$V281


basic_feature$V281<-ifelse(target$V281>0, 1,0)
Actual_Exp1_Feb1$V281<-ifelse(Actual_Exp1_Feb1$V281>0, 1,0)
Actual_Exp1_Feb2$V281<-ifelse(Actual_Exp1_Feb2$V281>0, 1,0)
Actual_Exp1_Mar1$V281<-ifelse(Actual_Exp1_Mar1$V281>0, 1,0)
Actual_Exp1_Mar2$V281<-ifelse(Actual_Exp1_Mar2$V281>0, 1,0)

LogisticRegression_Model_Exp1 <- glm(formula=V281~.,data=basic_feature,family = binomial(link = 'logit'))

summary(LogisticRegression_Model_Exp1)
"Lower value of AIC suggests better model, but it is a relative measure of model fit. It is used for model selection, i.e. it lets us compare different models estimated on the same dataset.

AIC of both the logistic models suggest there is no significant improvment after removing colinear features."

#Model Comparision Approach
#We will run both the regression algorithms on Categorical target and compare their rss.

#Running Linear Model on Categorical Target

testSet_Exp1_Feb1 <- B[c("V51","V52","V53","V54","V56","V57","V58","V59")]
testSet_Exp1_Feb2 <- C[c("V51","V52","V53","V54","V56","V57","V58","V59")]
testSet_Exp1_Mar1 <- D[c("V51","V52","V53","V54","V56","V57","V58","V59")]
testSet_Exp1_Mar2 <- E[c("V51","V52","V53","V54","V56","V57","V58","V59")]

basic_feature<-A[c("V51","V52","V53","V54","V56","V57","V58","V59")]
basic_feature$V281<-target$V281

basic_feature$V281<-ifelse(target$V281>0, 1,0)
target$V281<-ifelse(target$V281>0, 1,0)
LinearRegression_Model_Exp1 <- lm(formula=V281~V51+V52+V53+V54+V56+V57+V58+V59,data=basic_feature)

summary(LinearRegression_Model_Exp1)
#The above model also have a very low Multiple R-squared which means it is not a good model.


Lin_pred_onTrain<-predict(LinearRegression_Model_Exp1,basic_feature,se.fit=TRUE)
rss=sum((target-Lin_pred_onTrain$fit)^2)
print(paste0("rss on training data is ", rss))

Lin_pred_exp1_Feb1<-predict(LinearRegression_Model_Exp1,testSet_Exp1_Feb1,se.fit=TRUE)
rss=sum((Actual_Exp1_Feb1-Lin_pred_exp1_Feb1$fit)^2)
print(paste0("rss on Feb1 test data is ", rss))

Lin_pred_exp1_Feb2<-predict(LinearRegression_Model_Exp1,testSet_Exp1_Feb2,se.fit=TRUE)
rss=sum((Actual_Exp1_Feb2-Lin_pred_exp1_Feb1$fit)^2)
print(paste0("rss on Feb2 test data is ", rss))

Lin_pred_exp1_Mar1<-predict(LinearRegression_Model_Exp1,testSet_Exp1_Mar1,se.fit=TRUE)
rss=sum((Actual_Exp1_Mar1-Lin_pred_exp1_Feb1$fit)^2)
print(paste0("rss on Mar1 test data is ", rss))

Lin_pred_exp1_Mar2<-predict(LinearRegression_Model_Exp1,testSet_Exp1_Mar2,se.fit=TRUE)
rss=sum((Actual_Exp1_Mar2-Lin_pred_exp1_Feb1$fit)^2)
print(paste0("rss on Mar2 test data is ", rss))

#Model Comparision Conclusion for Experiment 1
#Linear Regression model's rss is better as compared to Logistic Regression when the target variable is categorical.


#Experiment 2

#Model 1-Linear Regression Model

testSet_Exp2_Feb1 <- B[63:262]
testSet_Exp2_Feb2 <- C[63:262]
testSet_Exp2_Mar1 <- D[63:262]
testSet_Exp2_Mar2 <- E[63:262]

Actual_Exp1_Feb1 <- B[281]
Actual_Exp1_Feb2 <- C[281]
Actual_Exp1_Mar1 <- D[281]
Actual_Exp1_Mar2 <- E[281]

textual_feature=A[63:262]
textual_feature$V281<-target$V281

typeof(Actual_Exp1_Feb1)


LinearRegression_Model_Exp2 <- lm(formula=V281~.,data=textual_feature)

Lin_pred_onTrain<-predict(LinearRegression_Model_Exp2,textual_feature,se.fit=TRUE)
rss=sum((target-Lin_pred_onTrain$fit)^2)
print(paste0("rss on training data is ", rss))

Lin_pred_exp2_Feb1<-predict(LinearRegression_Model_Exp2,testSet_Exp2_Feb1,se.fit=TRUE)
rss=sum((Actual_Exp1_Feb1-Lin_pred_exp2_Feb1$fit)^2)
print(paste0("rss on Feb1 test data is ", rss))

Lin_pred_exp2_Feb2<-predict(LinearRegression_Model_Exp2,testSet_Exp2_Feb2,se.fit=TRUE)
rss=sum((Actual_Exp1_Feb1-Lin_pred_exp2_Feb2$fit)^2)
print(paste0("rss on Feb2 test data is ", rss))

Lin_pred_exp2_Mar1<-predict(LinearRegression_Model_Exp2,testSet_Exp2_Mar1,se.fit=TRUE)
rss=sum((Actual_Exp1_Feb1-Lin_pred_exp2_Mar1$fit)^2)
print(paste0("rss on Mar1 test data is ", rss))

Lin_pred_exp2_Mar2<-predict(LinearRegression_Model_Exp2,testSet_Exp2_Mar2,se.fit=TRUE)
rss=sum((Actual_Exp1_Feb1-Lin_pred_exp2_Mar2$fit)^2)
print(paste0("rss on Mar2 test data is ", rss))

#The above model has rank deficiency. We should analyse our model's summary to check what went wrong.


LinearRegression_Model_Exp2

"To get rid of rank deficiency, need to remove following columns and rerun the Linear and Logistic models:

('V80','V200','V212','V236','V81','V243','V76','V94','V130','V166','V172','V190','V250','V149','V250','V149','V161','V179','V132','V156','V198','V73','V97','V169')"

drops <- c('V80','V200','V212','V236','V81','V243','V76','V94','V130','V166','V172','V190','V250','V149','V250','V149','V161','V179','V132','V156','V198','V73','V97','V169')
textual_feature<-textual_feature[ , !(names(textual_feature) %in% drops)]
testSet_Exp2_Feb1<-testSet_Exp2_Feb1[ , !(names(testSet_Exp2_Feb1) %in% drops)]
testSet_Exp2_Feb2<-testSet_Exp2_Feb2[ , !(names(testSet_Exp2_Feb2) %in% drops)]
testSet_Exp2_Mar1<-testSet_Exp2_Mar1[ , !(names(testSet_Exp2_Mar1) %in% drops)]
testSet_Exp2_Mar2<-testSet_Exp2_Mar2[ , !(names(testSet_Exp2_Mar2) %in% drops)]


# Running the linear model again after removing the columns which were causing rank deficiency

LinearRegression_Model_Exp2 <- lm(formula=V281~.,data=textual_feature)

Lin_pred_onTrain<-predict(LinearRegression_Model_Exp2,textual_feature,se.fit=TRUE)
rss=sum((target-Lin_pred_onTrain$fit)^2)
print(paste0("rss on training data is ", rss))

Lin_pred_exp2_Feb1<-predict(LinearRegression_Model_Exp2,testSet_Exp2_Feb1,se.fit=TRUE)
rss=sum((Actual_Exp1_Feb1-Lin_pred_exp2_Feb1$fit)^2)
print(paste0("rss on Feb1 test data is ", rss))

Lin_pred_exp2_Feb2<-predict(LinearRegression_Model_Exp2,testSet_Exp2_Feb2,se.fit=TRUE)
rss=sum((Actual_Exp1_Feb1-Lin_pred_exp2_Feb2$fit)^2)
print(paste0("rss on Feb2 test data is ", rss))

Lin_pred_exp2_Mar1<-predict(LinearRegression_Model_Exp2,testSet_Exp2_Mar1,se.fit=TRUE)
rss=sum((Actual_Exp1_Feb1-Lin_pred_exp2_Mar1$fit)^2)
print(paste0("rss on Mar1 test data is ", rss))

Lin_pred_exp2_Mar2<-predict(LinearRegression_Model_Exp2,testSet_Exp2_Mar2,se.fit=TRUE)
rss=sum((Actual_Exp1_Feb1-Lin_pred_exp2_Mar2$fit)^2)
print(paste0("rss on Mar2 test data is ", rss))


#Model 2-Logistic Regression Model


##Changing target variable to 0 and 1

basic_feature$V281<-ifelse(target$V281>0, 1,0)
Actual_Exp1_Feb1$V281<-ifelse(Actual_Exp1_Feb1$V281>0, 1,0)
Actual_Exp1_Feb2$V281<-ifelse(Actual_Exp1_Feb2$V281>0, 1,0)
Actual_Exp1_Mar1$V281<-ifelse(Actual_Exp1_Mar1$V281>0, 1,0)
Actual_Exp1_Mar2$V281<-ifelse(Actual_Exp1_Mar2$V281>0, 1,0)



LogisticRegression_Model_Exp2 <- glm(formula=V281~.,data=textual_feature,family = binomial(link = 'logit'))

summary(LogisticRegression_Model_Exp2)

Log_pred_onTrain<-predict(LogisticRegression_Model_Exp2,textual_feature,se.fit=TRUE)
rss=sum((target-Log_pred_onTrain$fit)^2)
print(paste0("rss on training data is ", rss))

Log_pred_exp2_Feb1<-predict(LogisticRegression_Model_Exp2,testSet_Exp2_Feb1,se.fit=TRUE)
rss=sum((Actual_Exp1_Feb1-Log_pred_exp2_Feb1$fit)^2)
print(paste0("rss on Feb1 test data is ", rss))

Log_pred_exp2_Feb2<-predict(LogisticRegression_Model_Exp2,testSet_Exp2_Feb2,se.fit=TRUE)
rss=sum((Actual_Exp1_Feb2-Log_pred_exp2_Feb2$fit)^2)
print(paste0("rss on Feb2 test data is ", rss))

Log_pred_exp2_Mar1<-predict(LogisticRegression_Model_Exp2,testSet_Exp2_Mar1,se.fit=TRUE)
rss=sum((Actual_Exp1_Mar1-Log_pred_exp2_Mar1$fit)^2)
print(paste0("rss on Mar1 test data is ", rss))

Log_pred_exp2_Mar2<-predict(LogisticRegression_Model_Exp2,testSet_Exp2_Mar2,se.fit=TRUE)
rss=sum((Actual_Exp1_Mar2-Log_pred_exp2_Mar2$fit)^2)
print(paste0("rss on Mar2 test data is ", rss))


#Model Comparision Approach

#Running Linear Model on Categorical Target

LinearRegression_Model_Exp2 <- lm(formula=V281~.,data=textual_feature)

Lin_pred_onTrain<-predict(LinearRegression_Model_Exp2,textual_feature,se.fit=TRUE)
rss=sum((target-Lin_pred_onTrain$fit)^2)
print(paste0("rss on training data is ", rss))

Lin_pred_exp2_Feb1<-predict(LinearRegression_Model_Exp2,testSet_Exp2_Feb1,se.fit=TRUE)
rss=sum((Actual_Exp1_Feb1-Lin_pred_exp2_Feb1$fit)^2)
print(paste0("rss on Feb1 test data is ", rss))

Lin_pred_exp2_Feb2<-predict(LinearRegression_Model_Exp2,testSet_Exp2_Feb2,se.fit=TRUE)
rss=sum((Actual_Exp1_Feb2-Lin_pred_exp2_Feb2$fit)^2)
print(paste0("rss on Feb2 test data is ", rss))

Lin_pred_exp2_Mar1<-predict(LinearRegression_Model_Exp2,testSet_Exp2_Mar1,se.fit=TRUE)
rss=sum((Actual_Exp1_Mar1-Lin_pred_exp2_Mar1$fit)^2)
print(paste0("rss on Mar1 test data is ", rss))

Lin_pred_exp2_Mar2<-predict(LinearRegression_Model_Exp2,testSet_Exp2_Mar2,se.fit=TRUE)
rss=sum((Actual_Exp1_Mar2-Lin_pred_exp2_Mar2$fit)^2)
print(paste0("rss on Mar2 test data is ", rss))


#Model Comparision Conclusion for Experiment 2
"Logistic Regression model's rss is better as compared to Linear Regression for Experiment two when the target variable is categorical."




###############################################

