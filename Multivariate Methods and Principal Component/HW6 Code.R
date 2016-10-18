
data <- c(7,4,6,8,8,7,5,9,7,8,4,1,3,6,5,2,3,5,4,2,3,8,5,1,7,9,3,8,5,2)
x <- matrix(data, nrow=10, ncol=3)
cov_matrix <- cov(x)

x1 <- x[,1]
x2 <- x[,2]
x3 <- x[,3]

PC1_load <- c(-.137571, -.250460, 0.958308)
PC2_load <- c(0.699037, 0.660889, 0.273080)

y1 <- x %*% t(t(PC1_load))
y2 <- x %*% t(t(PC2_load))

plot(y1, y2, main='Scatter Plot of Principle Component 1 and 2', xlab='y1', ylab='y2')

#Correlation Matrix

#First the eigenvectors 

PC1_ev <- c(-.137571, -.250460, 0.958308)
PC2_ev <- c(0.699037, 0.660889, 0.273080)

evalue1 <- 8.2739
evalue2 <- 3.6761

variance <- c(2.3222222222, 2.5, 7.8777777777)

(PC1_ev * sqrt(evalue1)) / sqrt(variance)
(PC2_ev * sqrt(evalue2)) / sqrt(variance)