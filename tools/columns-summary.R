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
# args= c("tools/test-data/irisPlus.tabular", "1", "somme", 'output')
# args= c("tools/test-data/irisPlus.tabular", "1", "moyenne", 'output')
# args= c("tools/test-data/irisPlus.tabular", "1", "ecartType", 'output')
# args= c("tools/test-data/irisPlus.tabular", "1", "ValeursSuperieuresAZero", 'output')
# args= c("tools/test-data/irisPlus.tabular", "1,2", "somme", 'output')
# args= c("tools/test-data/irisPlus.tabular", "1,2", "moyenne", 'output')
# args= c("tools/test-data/irisPlus.tabular", "1,2", "ecartType", 'output')
# args= c("tools/test-data/irisPlus.tabular", "1,2", "ValeursSuperieuresAZero", 'output')

## Import file
input <- data.frame(data.table::fread(args[1]))

## Create final size dataframe
result <- data.frame((matrix(NA, ncol = 0, nrow = 1)))

columnsSelected <- as.numeric(unlist(strsplit(args[2] , split = ",")))
outputOperation <- args[3]

#make new column names
columnNames <- paste(outputOperation, colnames(input)[columnsSelected], sep = "_")

if (length(columnsSelected) == 1){
  if (outputOperation == "moyenne"){
    result[1, 1] <- mean(input[ , columnsSelected], na.rm = TRUE)
  } else if ( outputOperation == "somme"){
    result[1, 1] <- sum(input[ , columnsSelected], na.rm = TRUE)
  } else if ( outputOperation == "ecartType"){
    result[1, 1] <- sd(input[ ,columnsSelected], na.rm = TRUE)
  } else if ( outputOperation == "ValeursSuperieuresAZero"){
    inputSelectZero <- input[ ,columnsSelected]
    inputSelectZero[inputSelectZero > 0] <- 1
    result[1, 1] <- sum(inputSelectZero, na.rm = TRUE)
  }
} else {
  if (outputOperation == "moyenne"){
    result[1, seq_along(columnsSelected)] <- colMeans(input[ , columnsSelected], na.rm = TRUE)
  } else if ( outputOperation == "somme"){
    result[1, seq_along(columnsSelected)] <- colSums(input[ , columnsSelected], na.rm = TRUE)
  } else if ( outputOperation == "ecartType"){
    result[1, seq_along(columnsSelected)] <-  apply(input[ ,columnsSelected], 2, function(x) sd(x, na.rm = TRUE))
  } else if ( outputOperation == "ValeursSuperieuresAZero"){
    inputSelectZero <- input[ ,columnsSelected]
    inputSelectZero[inputSelectZero > 0] <- 1
    result[1, seq_along(columnsSelected)] <- colSums(inputSelectZero, na.rm = TRUE)
  }
}
colnames(result) <- columnNames

write.table(result, file="result.csv", row.names=FALSE, sep=",")
