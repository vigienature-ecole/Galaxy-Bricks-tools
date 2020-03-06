#!/usr/bin/env Rscript

# get arguments from galaxy xlm command
args = commandArgs(trailingOnly=TRUE)
args <- c("tools/test-data/irisPlus.tabular", "5", "gauche", "3", "TipTop")

# import input file (tabular or csv)
input = data.frame(data.table::fread(args[1]))

# parameters
inputFile = args[1]
colNumber = as.numeric(args[2])
side = args[3]
charNumber = as.numeric(args[4])
colName <- args[5]

# select the characters
if (side = "droite"){
  colRes <- substr(input[ , colNumber], nchar(input[ , colNumber])-charNumber+1, nchar(input[ , colNumber]))
} else {
  colRes <- substr(input[ , colNumber], 0, charNumber)
}

# add results to the initial data.frame
output <- data.frame(input,colRes)

# rename column
colnames(output)[ncol(output)] <- colName

#write file
fwrite(output, "output-select-characters.tabular", sep =",")
