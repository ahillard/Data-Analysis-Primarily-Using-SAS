c <- matrix(c(1,1,-1,0, 0, -1), nrow=2, ncol=3)
y <- matrix(c(14, 24, 22))
s <- matrix(c(30,10,14,10,15,4,14,4,37), nrow=3, ncol=3)
n <- 25

t2 <- n * t(c %*% y) %*% solve( c %*% s %*% t(c) ) %*% (c %*% y)
F <- ((n-2)/((n-1)*2))*t2
qf(.975, 2, 23)

/*Part b*/

n1 <- 25
n2 <- 17
N <- 42 
k <-2

s1 <- matrix(c(30,10,14,10,15,4,14,4,37), nrow=3, ncol=3)
s2 <- matrix(c(26, 12, 10, 12, 17, 8, 10, 8, 43), nrow=3, ncol=3)
s_pooled <- ((n1-1)*s1+(n2-1)*s2)/((n1-1)+(n2-1))

det_s <- det(s_pooled)
det_s1 <- det(s1)
det_s2 <- det(s2)

M <- (N-k)*log(det_s)-(24*log(det_s1)+16*log(det_s2))

p <- 3

C1 <- 1 -((2*(p^2)+3*p-1)/(6*(p+1)*(k-1)))*((1/24)+1/16-1/40)

z <- matrix(c(15, 20, 24))

mahalanobis <- t(y-z)%*%solve(s_pooled)%*%(y-z)

((n1*n2)/(n1+n2))*mahalanobis

/*final part*/

diff <- y-z

t2 <- 42 * t(c %*% diff) %*% solve( c %*% s_pooled %*% t(c) ) %*% (c %*% diff)
F <- t2*(40/(41*2))
qf(.95, 2, 40)




