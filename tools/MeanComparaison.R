# tool for mean comparaison

# input file (tabular or csv)
input

# only to test make test file
y = rnorm(100,c(10,20),5)
x = rep(LETTERS[1:2],50)
inputTest <- data.frame(x, y)

# linear model
res <- t.test(inputTest$y~inputTest$x)
# output from linear model
res
# get residuals of the mode
residRes <- residuals(res)
# check for normality of the residuals
qqnorm(residRes)
qqline(residRes)
# plot data and add trend line
plot(inputTest$x, inputTest$y)
abline(res)