#!/usr/bin/env Rscript
#replace string or number


#get arguments from galaxy xlm command
args = commandArgs(trailingOnly=TRUE)

# import package
library(data.table) # for data import

# import input file (tabular or csv)
input = data.frame(fread(args[1]))

# get parameters
searchString = args[2]
replaceString = args[3]
allColumns = args[4]
columnNumber = as.numeric(args[5])
print(replaceString)

if (allColumns == FALSE){
  input[ ,columnNumber] <- gsub(searchString, replaceString, input[ ,columnNumber])
} else {
  input <- data.frame(lapply(input,function(x) {gsub(searchString, replaceString, x)}))
}

#write file
fwrite(input, "output-replace.tabular", sep =",")