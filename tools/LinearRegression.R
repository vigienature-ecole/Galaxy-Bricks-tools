#!/usr/bin/env Rscript

# tool for simple linear regression
#
#  Input :
#     1. dataset
#     2. dependant variable
#     3. explanatory variable
#  Output :
#     1. significance
#     2. coeficients
#     3. graph

#get arguments from galaxy xlm command
args = commandArgs(trailingOnly=TRUE)

# import package
library(data.table) # for data import

# import input file (tabular or csv)
input = data.frame(fread(args[1]))

# run linear model
res <- lm(input[ ,as.numeric(args[2])] ~ input[ ,as.numeric(args[3])])
# get output from linear model
results <- summary(res)

# Output 1 and 2
capture.output(results, file="mod-summary.txt")

# Output 3 Graph
# plot data and add trend line
png('output-plot.png')
plot(input[ ,as.numeric(args[3])], input[ ,as.numeric(args[2])])
abline(res)
invisible(dev.off())
