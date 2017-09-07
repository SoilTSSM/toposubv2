## generates ensemble matrix
#symbol, name, dist, supL, supU, mean, var

#x, coefVar, logit-normal, 0,0.8 0.4 0.01
#SoilAlbVisDry,
#pBias,
#tBias,


##matlab
#mu = 1
#cv = 0.4  
 
# https://msalganik.wordpress.com/2017/01/21/making-sense-of-the-rlnorm-function-in-r/

lognormDraws <- function(n, m,s)
	{
mu <- log(m^2 / sqrt(s^2 + m^2))
sigma <- sqrt(log(1 + (s^2 / m^2)))
draws <- rlnorm(n, mu, sigma)
	return(draws)
	}
	
normDraws <- function(n, m,s)
	{
draws <- rnorm(n, m, s)
	return(draws)
	}

logitnormDraws <- function(n, m,s)
	{
	require(logitnorm)
mu <- log(m^2 / sqrt(s^2 + m^2))
sigma <- sqrt(log(1 + (s^2 / m^2)))
draws <- rlogitnorm(n , mu, sigma)
	return(draws)
	}
	

N=10
cv=lognormDraws(N,0.4,0.01)	
alpha=lognormDraws(N,0.2,0.01)	# SoilAlbVisDry
pbias=lognormDraws(N,1,1)	
tbias=normDraws(N,0,1)
df=data.frame(cv,alpha,pbias,tbias)

par(mfrow=c(2,2))
plot(density(df$tbias))
plot(density(df$pbias))
plot(density(df$alpha))
plot(density(df$cv))






 

