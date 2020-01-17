#!/usr/bin/env Rscript

# tool for anova analysis
#
#  Input :
#     1. dataset
#     2. dependant variable
#     3. explanatory variable (can be more than one)
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

# find if there is more than one explanatory variable (separator = , )
multiple = grepl(",", args[3])

# Build formula
if (multiple) {
  varExpl <- as.numeric(unlist(strsplit(args[3], ",")))
  formulaMod <- as.formula(paste(
    colnames(input)[as.numeric(args[2])],
    " ~ " ,
    paste(colnames(input)[varExpl], collapse = ' + '))
  )

} else {
  formulaMod <- as.formula(paste(colnames(input)[as.numeric(args[2])]," ~ " , colnames(input)[as.numeric(args[3])]))
}

# run anova

res <- aov(formulaMod, data = input)

# get output from linear model
results <- summary(res)

# Output 1 and 2
capture.output(results, file="mod-summary.txt")


# Output 3 Graph
# plot data and add trend line
png('output-plot.png')
boxplot(formulaMod, data = input)
invisible(dev.off())
