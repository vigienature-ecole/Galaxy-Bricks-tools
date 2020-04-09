#######################################"
#    SIMPLE OPERATIONS ON COLUMNS
#    Translate a formula to perform operations on a dataset (mainly on columns)
#    Date 29.05.2019
#    Author : Simon Benateau
###########################################

library(data.table)
library(stringr)

#get arguments from galaxy xlm command
args = commandArgs(trailingOnly=TRUE)
#args= c("tools/test-data/irisPlus.tabular", "c1 + c2", "test")
args= c("../../Downloads/Galaxy13-[R_sumer_des_donn_es_on_data_12].csv", "c2 / c3", "test")

# load data and formula from form
inputData <- fread(args[1])
inputFormula = args[2]
inputName = args[3]

#deal with NA (A bit uncool !)
#inputData[is.na(inputData)] <- 0

#check the formula for security reasons
evalFormula <- inputFormula
functions <- c("log[(]", "log10[(]" ,"exp[(]" ,"sqrt[(]" ,"asin[(]" ,"acos[(]" ,"sin[(]" ,"tan[(]" ,"atan[(]" ,"cos[(]", "sum[()]", "mean[(]", "var[(]", "sd[(]")
for (i in seq_along(functions)) evalFormula <- gsub(functions[i],"",evalFormula)
resultEval <- grepl("^[0-9 c+^/*%(). -- -]+$",evalFormula)

if (resultEval){

  if (inputName == "") inputName = inputFormula

  # change column names to column code to match formula syntax
  transformedData <- inputData
  colnames(transformedData) <- c(paste0("c",1:ncol(inputData)))

  whereToAdd <- str_locate_all(inputFormula, "c[0-9][0-9][0-9]|c[0-9][0-9]|c[0-9]")
  EndFormula <- inputFormula
  for (i in 1:nrow(whereToAdd[[1]])){

    frontReplacementInFormula <- gsub(paste0('^(.{',whereToAdd[[1]][i,1]-1 + (i-1) * 21,'})(.*)$'), '\\1transformedData[ ,"\\2', EndFormula)
    totalReplacementInFormula <- gsub(paste0('^(.{',whereToAdd[[1]][i,2] + 19 + (i-1) * 21,'})(.*)$'), '\\1"]\\2', frontReplacementInFormula)
    EndFormula <- gsub(pattern = '"', replacement = "'", totalReplacementInFormula, fixed = TRUE)
  }

  #strsplit(inputFormula, split = " ")

  # change the formula
  #formulaIndexed <- gsub("c", "transformedData$c",inputFormula)

  # apply formula to the data
  resultData <- data.frame(eval(parse(text=EndFormula)))

  # change the name of the result column
  colnames(resultData) <- inputName

  # add column to original file
  resultData <- data.frame(inputData, resultData)

  # write output file
  fwrite(resultData, file = "result.csv", sep = ",")
} else {
  print("Formula not valid")
}
