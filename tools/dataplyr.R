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
# args= c("tools/test-data/irisPlus.tabular", "5,6","1","somme","toto", "output")
# 
# 
# args= c("tools/test-data/irisPlus.tabular", "5,6","1,2,3","moyenne", "ecartType", "output")




#args= c("tools/test-data/irisPlus.tabular", "5,6","5","somme","toto", "output")

#determine the number of loop count
totalLoop = (length(args) - 4)


# for the functions in french and to deal with NA

somme <- function (x) sum(x, na.rm = TRUE)
moyenne <- function (x) mean(x, na.rm = TRUE)
mediane <- function (x) median(x, na.rm = TRUE)
ecartType <- function (x) sd(x, na.rm = TRUE)
minimum <- function (x) min(x, na.rm = TRUE)
maximum <- function (x) max(x, na.rm = TRUE)
compte <- function (x) length(x)
compteSuperieurAZero <- function (x) length(x[x>0 & !is.na(x)])
erreurStandard <- function (x) sd(x, na.rm = TRUE)/length(x[!is.na(x)])


# import package
library(data.table) # for data import
library(dplyr, warn.conflicts = FALSE)


# import input file (tabular or csv)
input = data.frame(fread(args[1]))

Result <- list()

# separate variables
columnsGroup <- as.numeric(unlist(strsplit(args[2], ",")))
if(columnsGroup[1] == "None") stop("Il faut sélectionner une colonne de regroupement")
columnsOperation <- as.numeric(unlist(strsplit(args[3], ",")))
if(any(columnsOperation %in% columnsGroup)) stop(paste("Il est impossible de sélectionner une colonne pour faire une opération si elle est déjà sélectionnée pour le regroupement.",
                                           "Peut-être devrier vous retirer la variable", colnames(input)[columnsOperation],"de la partie regroupement"))


for (i in 1:totalLoop){
  
  # separate functions
  functions <- unlist(strsplit(args[4 + (i-1)], ","))

  #gets names from arguments TO CHANGE
  newNames <- args[5 + (i-1) * 2]

  # Agregation function
  Result[[i]] <- input %>%
    group_by_at(colnames(input)[columnsGroup]) %>%
    summarise_at(.vars = colnames(input)[columnsOperation], .funs = functions)

  # change colnames to make them more comprehensible (operation_variable name)
    toRename <- colnames(Result[[i]]) %in% colnames(input)[columnsOperation]
    colnames(Result[[i]])[toRename] <- paste(functions, colnames(input)[columnsOperation], sep = "_")
}

finalResult <- Result[[1]]
if (totalLoop > 1){
  for (i in 2:totalLoop){
    finalResult <- data.frame(finalResult,Result[[i]][ ,(length(columnsGroup) + 1):(length(columnsGroup) + length(columnsOperation)) ])
  }
}


# write result
fwrite(finalResult, file = "output-dataplyr.csv", sep = ",")
