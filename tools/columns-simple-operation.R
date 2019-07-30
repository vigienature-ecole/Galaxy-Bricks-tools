#######################################"
#    SIMPLE OPERATIONS ON COLUMNS
#    Translate a formula to perform operations on a dataset (mainly on columns)
#    Date 29.05.2019
#    Author : Simon Benateau
###########################################

library(data.table)

#get arguments from galaxy xlm command
args = commandArgs(trailingOnly=TRUE)

# load data and formula from form
inputData <- fread(args[1])
inputFormula = args[2]
inputName = args[3]

#check the formula for security reasons

evalFormula <- inputFormula
functions <- c("log[(]","exp[(]","sqrt[(]","asin[(]","acos[(]","sin[(]","tan[(]","atan[(]","cos[(]")
for (i in seq_along(functions)) evalFormula <- gsub(functions[2],"",evalFormula)
resultEval <- grepl("^[0-9 c+-*/^%()]+$",evalFormula)

if (resultEval){

  if (inputName == "") inputName = inputFormula

  # change column names to column code to match formula syntax
  transformedData <- inputData
  colnames(transformedData) <- c(paste0("c",1:ncol(inputData)))

  # change the formula
  formulaIndexed <- gsub("c", "transformedData$c",inputFormula)

  # apply formula to the data
  resultData <- data.frame(eval(parse(text=formulaIndexed)))

  # change the name of the result column
  colnames(resultData) <- inputName

  # add column to original file if asked
  if (args[4] == TRUE) resultData <- data.frame(inputData, resultData)

  # write output file
  write.table(resultData, file="result", row.names=FALSE, sep="\t")
} else {
  print("Formula not valid")
}
