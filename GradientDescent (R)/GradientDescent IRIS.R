mdata<-read.csv('/Users/shashankkumar/Studies/SecondSem/ML/dataset/iris.csv',header=TRUE, sep=",",)

summary(mdata)
m=nrow(mdata)
x0<-list(rep(1, m))
names(x0)<-'x0'
x<-as.matrix(cbind(x0,mdata[,-5]))
y<-as.matrix(mdata$class)
theta <- as.matrix(c(rep(0,5)))
temp_theta<-theta

grad <- function(x, y, theta)
{
  
  temp_theta <- (1/m)* (t(x) %*% ((x %*% theta) - y))
  return(temp_theta)
  
}
grad(x,y,theta)
grad.descent<-function(x,maxit,a,theta)
{
  for (i in 1:maxit)
  {
    theta<-theta-a*grad(x,y,theta)
  }
  return(theta)
}

a=0.01
maxit=10000
print(grad.descent(x,maxit,a,theta))
a=0.001
maxit=100000
print(grad.descent(x,maxit,a,theta))
a=0.005
maxit=500000
print(grad.descent(x,maxit,a,theta))