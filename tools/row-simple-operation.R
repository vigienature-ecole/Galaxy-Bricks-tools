#######################################"
#    SIMPLE OPERATIONS ON LINES
#    apply operation on the choosen columns of a dataset
#    Date 19.03.2020
#    Author : Simon Benateau
###########################################

library(data.table)

#get arguments from galaxy xlm command
args = commandArgs(trailingOnly=TRUE)
#args <- c("tools/test-data/irisPlus.tabular", "1,2,3,4", "5,6", "moyenne", "test", "output")
#args <- c("tools/test-data/irisPlus.tabular", "1,2,3,4", "5,6", "somme", "test", "valeurs-superieures-a-zero", "test2", "output")
#args <- c("../../Downloads/Données_VNE_Operation_escargot.csv.csv", paste(58:88, collapse = ","), "None", "valeurs-superieures-a-zero", "test", "output")

#determine the number of loop count
totalLoop = (length(args) - 4) / 2

# import input file (tabular or csv)
input = data.frame(data.table::fread(args[1]))

#select columns for the operation(s)
columnOperationNbr = as.numeric(unlist(strsplit(args[2] , split = ",")))
columnOperation = input[ , columnOperationNbr]
#select final dataset
if (args[3] != "None"){
  columnSelectNbr = as.numeric(unlist(strsplit(args[3] , split = ",")))
  finalDataset = input[ , columnSelectNbr]
} else {
  finalDataset = input
}

for (i in 1:totalLoop){
  result = NA
  # parameters
  operation = args[4 + (i-1) * 2]
  outputName = args[5 + (i-1) * 2]

  if (operation == "moyenne") {
    result <- rowMeans(columnOperation, na.rm = TRUE)
  } else if (operation == "somme"){
    result <- rowSums(columnOperation, na.rm = TRUE)
  } else if (operation == "ecart-type"){
    result <- rowSds(columnOperation, na.rm = TRUE)
  } else if (operation == "valeurs-superieures-a-zero"){
    columnOperationZero <- columnOperation
    columnOperationZero[columnOperationZero > 0] <- 1
    result <- rowSums(columnOperationZero, na.rm = TRUE)
  }

  finalDataset <- data.frame(finalDataset, result)
  colnames(finalDataset)[ncol(finalDataset)] <- outputName

}


# write output file
fwrite(finalDataset, file = "result.csv", sep = ",")
