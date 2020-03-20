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
#args= c("tools/test-data/irisPlus.tabular", "1","youhou","somme", 'output')
#args= c("tools/test-data/irisPlus.tabular", "1","youhou","mediane", "1","tada","moyenne", 'output')

#determine the number of loop count
totalLoop = (length(args) - 2) / 3

## Import file
input <- data.frame(data.table::fread(args[1]))

## Create final size dataframe
result <- data.frame((matrix(NA, ncol = 0, nrow = 1)))

## Add new column
for (i in 1:totalLoop){
  
  columnSelected <- as.numeric(args[2 + (i-1) * 3])
  outputName <- args[3 + (i-1) * 3]
  outputOperation <- args[4 + (i-1) * 3]
  
  if (outputOperation == "moyenne"){
    result[1, outputName] <- mean(input[ ,columnSelected], na.rm = TRUE)
  } else if ( outputOperation == "somme"){
    result[1, outputName] <- sum(input[ , columnSelected], na.rm = TRUE)
  } else if ( outputOperation == "ecartType"){
    result[1, outputName] <- sd(input[ ,columnSelected], na.rm = TRUE)
  } else if ( outputOperation == "ValeursSuperieuresAZero"){
    inputSelectZero <- input[ ,columnSelected]
    inputSelectZero[inputSelectZero > 0] <- 1
    result[1, outputName] <- sum(inputSelectZero, na.rm = TRUE)
  }
}
  
  write.table(result, file="result.csv", row.names=FALSE, sep=",")