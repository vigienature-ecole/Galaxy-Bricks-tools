#!/usr/bin/env Rscript

# tool aggregation and descriptive statistiques
#
#  Input :
#     1. dataset
#     2. columns to group by
#     3. column for calculation
#  Output :
#     1. table

#get arguments from galaxy xlm command
args = commandArgs(trailingOnly=TRUE)

# import package
library(data.table) # for data import
library(dplyr)

# separate variables
columnsGroup <- as.numeric(unlist(strsplit(args[2], ",")))
columnOperation <- as.numeric(unlist(strsplit(args[3], ",")))
# separate functions
functions <- unlist(strsplit(args[4], ","))

#change functions to deal with NA
functions <- paste0(functions,"2")

sum2 <- function (x) sum(x, na.rm = TRUE)
mean2 <- function (x) mean(x, na.rm = TRUE)
median2 <- function (x) median(x, na.rm = TRUE)
sd2 <- function (x) sd(x, na.rm = TRUE)
min2 <- function (x) min(x, na.rm = TRUE)
max2 <- function (x) max(x, na.rm = TRUE)
length2 <- function (x) length(x)

# import input file (tabular or csv)
input = data.frame(fread(args[1]))

# Agregation function
Result <- input %>%
  group_by_at(colnames(input)[columnsGroup]) %>%
  summarise_at(.vars = colnames(input)[columnOperation], .funs = functions)

# change colnames to make them more comprehensible (operation_variable name)
if (length(functions) == 1){
  toRename <- colnames(Result) %in% colnames(input)[columnOperation]
  colnames(Result)[toRename] <- paste0(functions, "_", colnames(input)[columnOperation])
} else {
  toRename <- colnames(Result) %in% functions
  colnames(Result)[toRename] <- paste0(colnames(Result)[toRename], "_", colnames(input)[columnOperation])
}

# write result
fwrite(Result, file = "output-dataplyr.tabular", sep = ",")
