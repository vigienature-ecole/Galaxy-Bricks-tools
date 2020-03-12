#!/usr/bin/env Rscript

#get arguments from galaxy xlm command
args = commandArgs(trailingOnly=TRUE)
#args = c("tools/test-data/irisPlus.tabular", "5", "6", "NewName")

# import input file (tabular or csv)
input = data.frame(data.table::fread(args[1]))

#concatenate columns
concatenatedColumns <- paste0(input[, as.numeric(args[2])], input[, as.numeric(args[3])])

#add column to the data.frame
output <- data.frame(input, concatenatedColumns)

#rename output column
colnames(output)[ncol(output)] <- args[4]

data.table::fwrite(output, file = "output-concatenate.csv", sep = ",")
