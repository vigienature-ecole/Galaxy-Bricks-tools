#######################################"
#    SORT DATASET
#    Sort all the lines of a dataset according to the values of one column
#    Date 19.03.2020
#    Author : Simon Benateau
###########################################

library(data.table)

#get arguments from galaxy xlm command
args = commandArgs(trailingOnly=TRUE)
#args <- c("tools/test-data/irisPlus.tabular", "2", "croissant")
#args <- c("tools/test-data/irisPlus.tabular", "2", "decroissant")

# import input file (tabular or csv)
input = data.frame(data.table::fread(args[1]))

# parameters
columnNumber = as.numeric(args[2])
side = args[3]

#sort the dataframe
if (side == "croissant") {
  result <- dplyr::arrange(input, input[[colnames(input)[columnNumber]]])
} else {
  result <- dplyr::arrange(input, desc(input[[colnames(input)[columnNumber]]]))
}

# write output file
fwrite(result, file = "result.csv", sep = ",")