#!/usr/bin/env Rscript

# tools to filter specific column

#get arguments from galaxy xlm command
args = commandArgs(trailingOnly=TRUE)

# import package
library(data.table) # for data import
library(stringr) # to work with string
library(dplyr)


# parameters translated
#type = 
# add numeric / not numeric
negateMatching = args[2]
filterParameter = args[3]
wholeLine = args[4]
columnsNumber = as.numeric(args[5])


# import input file (tabular or csv)
input = data.frame(fread(args[1]))


#select lines
if (wholeLine == FALSE){
  if (negateMatching == FALSE){
  result <- dplyr::filter(input, str_detect(input[ ,columnsNumber], filterParameter))
  print("you")
  } else {
    result <- dplyr::filter(input, !str_detect(input[ ,columnsNumber], filterParameter))
  }
} else {
  if (negateMatching == FALSE){
  result <- dplyr::filter_all(input, any_vars(str_detect(., filterParameter)))
  } else {
    result <- input[apply(input, 1, function (x) !any(str_detect(x, filterParameter))), ]
  }
}
#write file
fwrite(result, "output-filter.tabular", sep =",")

