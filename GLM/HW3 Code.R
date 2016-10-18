
x0 <- c(1, 1, 1, 1, 1, 1, 1)
x1 <- c(0, 1, 1, 0, 1, 0, 1) 
x2 <- c(35, 60, 25, 20, 50, 55, 30)
y <- c(3, 16, 12, 1, 18, 8, 9)
b <- c(2.5, -.5, -.01)

easy <- function(x1, x2) {exp(2.5-.5*x1-0.01*x2)}

easy(x1, x2)
x1*y
x2*y

F <- cbind(t(t(easy(x1, x2))), t(t(easy(x1, x2)*x1)), t(t(easy(x1, x2)*x2)))

obs <- cbind(x0, x1, x2)
est <- obs %*% b
exp(est) + ((exp(est))^2)/15

V <- matrix(c(13.498178,0,0,0,0,0,0, 0, 5.151510,0,0,0,0,0,0,0,7.962299,0,0,0,0,0,0,0,16.606470,0,0,0,0,0,0,0,5.820725,0,0,0,0,0,0,0,10.322184,0,0,0,0,0,0,0,7.471554),nrow=7, ncol=7) 

## New Betas

u <- exp(obs %*% b)
b1 <- t(t(b)) + solve(t(F) %*% solve(V) %*% F) %*% t(F) %*% solve(V) %*% (t(t(y)) - u)


##Wald Test

L <- matrix(ncol=3, nrow=2, c(0, 0, 1, 0, 0, 1))

t((L %*% t(t(b)))) %*% solve(L %*% solve((t(F) %*% solve(V) %*% F)) %*% t(L)) %*% (L %*% t(t(b)))

