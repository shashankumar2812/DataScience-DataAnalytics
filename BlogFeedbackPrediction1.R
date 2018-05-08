A <- read.csv('/Users/shashankkumar/Studies/SecondSem/ML/Assignments/Assignment2/Dataset/BlogFeedback/blogData_train.csv',header=FALSE,sep=",",)

#Data Preparation for Experiment 
#Setting the column names across the dataset

for(i in 1:281){names(A)[ncol(A)] <- paste0("V", i)}

# Correlation Matrix

cormat <- round(cor(basic_feature),2)
cormat

''' 
We will remove V55 and V60 features as they are derived from other columns of the dataset. 
'''


data<-A[sample(1:nrow(A), 5000,replace=FALSE),]




target<-data[281]
#basic features
Ax<-data[c("V51","V52","V53","V54","V56","V57","V58","V59")]
scaled.A <- scale(Ax,center=TRUE)


# Changing target variable to 0 and 1
target$V281<-ifelse(target$V281>0, 1,0)

Ay <-target
basic_feature = cbind(scaled.A, Ay)

#Splitting data into train and test
# Set Seed so that same sample can be reproduced in future also
set.seed(101)
# Now Selecting 80% of data as sample from total 'n' rows of the data  
sample <- sample.int(n = nrow(basic_feature), size = floor(.8*nrow(data)), replace = F)
train <- basic_feature[sample, ]
test  <- basic_feature[-sample, ]

#Adhoc solution

LogisticRegression_Model_Exp1 <- glm(formula=V281~.,data=train,family = binomial(link = 'logit'))

summary(LogisticRegression_Model_Exp1)

Log_pred_on_Train<-predict(LogisticRegression_Model_Exp1,train,se.fit=TRUE)
Log_pred_on_Test<-predict(LogisticRegression_Model_Exp1,test,se.fit=TRUE)

#Calculating rss ans mse using adhoc solution

train_residual = target-Log_pred_on_Train$fit
dim(train_residual)
test_residual = target-Log_pred_on_Test$fit
dim(test_residual)

train_mse_adhoc=mean(train_residual^2)
train_rss_adhoc=sum(train_residual^2)

test_mse_adhoc=mean(test_residual^2)
test_rss_adhoc=sum(test_residual^2)


#train_rss=sum((target-Log_pred_on_Train$fit)^2)
#test_rss=sum((target-Log_pred_on_Test$fit)^2)
print(paste0("rss on train data for adhoc solution Logistic regression is ", train_rss_adhoc))
print(paste0("rss on test data for adhoc solution Logistic regression is ", test_rss_adhoc))

print(paste0("mse on train data for adhoc solution Logistic regression is ", train_mse_adhoc))
print(paste0("mse on test data for adhoc solution Logistic regression is ", test_mse_adhoc))


#Separating features and target
train_X=train[,1:ncol(train)-1]
train_X
train_Y=train[,ncol(train)]


test_X=test[,1:ncol(test)-1]
test_X
test_Y=test[,ncol(test)]

# convert data to matrix form so that it can consumed by R-mosek

train_X=as.matrix(train_X)
train_Y=as.matrix(train_Y)

test_X=as.matrix(test_X)
test_Y=as.matrix(test_Y)

#Ordinary Least Squares# Minimizing (actual -predicted)^2 
obj.func<-function(X,y, verb=1){
  #number of parameters of interest
  noOfFeatures<-dim(X)[2] 
  #coefficients=(inverse(X'X))(X'y)
  X.square.inv<-solve(t(X)%*% X)
  #objective coefficients
  c<-as.vector(X.square.inv%*%(t(X)%*%y))
  #problem definition in Mosek
  #initializing list 
  qp<-list() 
  #Problem objective is to minimize 
  qp$sense<-"min" 
  #objective coefficients
  qp$c<-c
  #Constraint Matrix
  qp$A<-Matrix(as.matrix(X))
  blc<-rep(0,dim(X)[1])
  buc<-rep(Inf,dim(X)[1])  
  qp$bc<-rbind(blc,buc)
  blx<-c(min(X[,1]),min(X[,2]),min(X[,3]),min(X[,4]),min(X[,5]),min(X[,6]),min(X[,7]),min(X[,8])) 
  bux<-c(max(X[,1]),max(X[,2]),max(X[,3]),max(X[,4]),max(X[,5]),max(X[,6]),max(X[,7]),max(X[,8]))
  qp$bx<-rbind(blx,bux)
  qp$bc<-rbind(blc, buc) #constraint bounds
  
  #Solving with mosek solver
  result<-mosek(qp, opts = list(verbose = verb)) 
  return(result)
}

mosek_result=obj.func(train_X, train_Y)
mosek_result

#Creating the equation using the coefficients obtained from solving the optimizing problem using rmosek
y_train_pred_mosek= train_X %*% mosek_result$sol$bas$xx
typeof(mosek_result$sol$bas$xx)

head(y_train_pred_mosek)
y_test_pred_mosek= test_X %*% mosek_result$sol$bas$xx
dim(test_X)
dim(mosek_result$sol$bas$xx)
head(y_test_pred_mosek)

train_residual = train_Y-y_train_pred_mosek
test_residual = test_Y-y_test_pred_mosek

train_mse_mosek=mean(train_residual^2)
train_rss_mosek=sum(train_residual)
train_mse_mosek
train_rss_mosek

test_mse_mosek=mean(test_residual^2)
test_rss_mosek=sum(test_residual)
test_mse_mosek
test_rss_mosek































