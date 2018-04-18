#Gradient Descent - OLS 
# Get data
irisData=read.csv('/Users/shashankkumar/Studies/SecondSem/ML/dataset/iris.csv',header=TRUE,sep=",")
#create X matrix
x <-irisData[,1:4]
x.scaled<-as.matrix(scale(x[,1:4]))
#create Y matrix - Dependent variable / Target Concept
y<-irisData[,5]
#Get the number of rows
m<-nrow(x)
#Get the number of cols
n<-ncol(x)
# Initialize the weight matrix
w <- matrix(c(0, 0, 0, 0), nrow=1) 

#Use the lm function to build a model
# This uses QR decomposition to come up with the solution to Ax=b
f<-lm(formula=y~x.scaled[,1]+x.scaled[,2]+x.scaled[,3]+x.scaled[,4])
print(summary(f))
pred1<-f$coefficients[1]+ f$coefficients[2]*x[,1] + f$coefficients[3]*x[,2] + f$coefficients[4]*x[,3] + f$coefficients[5]*x[,4]
sqLoss1=(y-pred1)^2
mse1=mean(sqLoss1)
print(mse1)

# ----------------------------------------------------------------------- 
#Start working on the gradient descent algorithm
# ----------------------------------------------------------------------- 
#squared loss J= (y-h(x))^2 where h(x)=w*x
# define the gradient function dJ/dw: 1/m * 2(h(x)-y))*x where h(x) = x*w
# in matrix form this is as follows:
grad <- function(x, y, w) 
{
  gradient<- c(0,0,0,0)
  for (i in 1:m)
  {
  	 gradient <- gradient + (x[i,] * (x[i,] %*% t(w) - y[i]))
  }	 
  return(gradient)
}

gradMat <- function(x, y, w) 
{
  gradMat <- t(x) %*% (x %*% t(w) - y)
  return(t(gradMat))
}

secGradMat <- function(x)
{
	secGrad<-2 * as.matrix(t(x)) %*% as.matrix(x)
	return(solve(secGrad))
}

# define gradient descent update algorithm
grad.descent <- function(x, maxit)
{
	# set learning rate
	alpha = .5 
    for (i in 1:maxit) 
    {
      w <- w - alpha  * (1/m) * grad(x, y, w) 
    }
 return(w)
}

# define gradient descent update algorithm
grad.descent1 <- function(x, maxit)
{
	# set learning rate
	alpha = .5 
    for (i in 1:maxit) 
    {
      w <- w - alpha  * (1/m) * gradMat(x, y, w) 
    }
 return(w)
}
  
# get results from gradient descent
beta <- grad.descent(x.scaled,10)
print(beta)
beta1<-grad.descent1(x.scaled,10)
print(beta1)
pred2 <- t(mat.or.vec(1,m)) 
pred3 <- t(mat.or.vec(1,m)) 
# define the 'hypothesis function'
for(j in 1:m) 
{
	pred2[j,1] <- x.scaled[j,1]*beta[1,1] + x.scaled[j,2]*beta[1,2] + x.scaled[j,3]*beta[1,3] + x.scaled[j,4]*beta[1,4]
	pred3[j,1] <- x.scaled[j,1]*beta1[1,1] + x.scaled[j,2]*beta1[1,2] + x.scaled[j,3]*beta1[1,3] + x.scaled[j,4]*beta1[1,4]
}
#Performance metric is squared loss
sqLoss2=(y-pred2)^2
mse2=mean(sqLoss2)
print(mse2)
#print(pred2)

sqLoss3=(y-pred3)^2
mse3=mean(sqLoss3)
print(mse3)
#print(pred3)

# define update by Newton's Method
newton.descent <- function(x, maxit)
{
    for (i in 1:maxit) 
    {
      w <- w - (1/m) * as.matrix(beta1) %*% as.matrix(secGradMat(x))
    }
 return(w)
}
# get results from gradient descent
beta.Newton <- newton.descent(x.scaled,2)
print(beta.Newton)
pred4 <- t(mat.or.vec(1,m)) 
for(j in 1:m) 
{
	pred4[j,1] <- x.scaled[j,1]*beta.Newton[1,1] + x.scaled[j,2]*beta.Newton[1,2] + x.scaled[j,3]*beta.Newton[1,3] + x.scaled[j,4]*beta.Newton[1,4]
}
sqLoss4=(y-pred4)^2
mse4=mean(sqLoss4)
print(mse4)