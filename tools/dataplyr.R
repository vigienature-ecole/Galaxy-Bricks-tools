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
#args= c("tools/test-data/irisPlus.tabular", "5,6","1","somme","toto", "output")
#args= c("tools/test-data/irisPlus.tabular", "5,6","1","moyenne","toto", "1","ecartType","toto2", "output")
#args= c("tools/test-data/irisPlus.tabular", "5,6","5","somme","toto", "output")

#determine the number of loop count
totalLoop = (length(args) - 3) / 3


# for the functions in french and to deal with NA

somme <- function (x) sum(x, na.rm = TRUE)
moyenne <- function (x) mean(x, na.rm = TRUE)
mediane <- function (x) median(x, na.rm = TRUE)
ecartType <- function (x) sd(x, na.rm = TRUE)
minimum <- function (x) min(x, na.rm = TRUE)
maximum <- function (x) max(x, na.rm = TRUE)
compte <- function (x) length(x)


# import package
library(data.table) # for data import
library(dplyr, warn.conflicts = FALSE)


# import input file (tabular or csv)
input = data.frame(fread(args[1]))

Result <- list()

# separate variables
columnsGroup <- as.numeric(unlist(strsplit(args[2], ",")))
if(columnsGroup == "None") stop("Il faut sélectionner une colonne de regroupement")

for (i in 1:totalLoop){
  columnOperation <- as.numeric(unlist(strsplit(args[3 + (i-1) * 3], ",")))
  # separate functions
  functions <- unlist(strsplit(args[4 + (i-1) * 3], ","))

  if(columnOperation %in% columnsGroup) stop("Il est impossible de sélectionner une colonne pour faire une opération si elle est déjà sélectionnée pour le regroupement")

  #gets names from arguments
  newNames <- args[5 + (i-1) * 3]

  # Agregation function
  Result[[i]] <- input %>%
    group_by_at(colnames(input)[columnsGroup]) %>%
    summarise_at(.vars = colnames(input)[columnOperation], .funs = functions)

  # change colnames to make them more comprehensible (operation_variable name)
    toRename <- colnames(Result[[i]]) %in% colnames(input)[columnOperation]
    colnames(Result[[i]])[toRename] <- newNames
}

finalResult <- Result[[1]]
if (totalLoop > 1){
  for (i in 2:totalLoop){
    finalResult <- data.frame(finalResult,Result[[i]][ ,ncol(Result[[i]])])
  }
}


# write result
fwrite(finalResult, file = "output-dataplyr.csv", sep = ",")
