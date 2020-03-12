#!/usr/bin/env Rscript

# tool to select specific columns

#get arguments from galaxy xlm command
args = commandArgs(trailingOnly=TRUE)

# import package
library(data.table, quietly = TRUE) # for data import
library(dplyr)

# import input file (tabular or csv)
input = data.frame(fread(args[1], encoding = "UTF-8"))

# parameters
columns = as.numeric(unlist(strsplit(args[2], ",")))
negate = args[3]

# revert column selection if negate is true
if (negate == "supprimer") columns <- (1:ncol(input))[!1:ncol(input) %in% columns]

# select columns
result <- input[ ,columns]

#write file
fwrite(result, "output-select.csv", sep =",")
