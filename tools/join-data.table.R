#!/usr/bin/env Rscript

########
#
#    data.table tool for galaxy bricks
#      author : simon benateau
#      date : 28.08.2019
#
#######

#get arguments from galaxy xlm command
args = commandArgs(trailingOnly=TRUE)

# load library
library(data.table)

# input data
# args = c("input1-join.tabular", "input2-join.tabular", "INNER", "1", "1", "2,3", "1,3", "TRUE")

input1 = fread(args[1])
input2 = fread(args[2])

# select the columns to keep

columnToKeep1 <- colnames(input1)[as.numeric(unlist(strsplit(args[6], ",")))]
columnToKeep2 <- colnames(input2)[as.numeric(unlist(strsplit(args[7], ",")))]

key_id1 <- colnames(input1)[as.numeric(args[4])]
key_id2 <- colnames(input2)[as.numeric(args[5])]

# check if the key is missing
key1_in = key_id1 %in% columnToKeep1
key2_in = key_id2 %in% columnToKeep2

if (!key1_in){
  columnToKeep1 <- c(key_id1, columnToKeep1)
}


if (!key2_in){
  columnToKeep2 <- c(key_id2, columnToKeep2)
}

# select the columns
input1 <- input1[ , columnToKeep1, with=FALSE]
input2 <- input2[ , columnToKeep2, with=FALSE]

# set the keys

# rename the columns if needed

setnames(input2, key_id2, key_id1)
# set keys
setkeyv(input1, key_id1)
setkeyv(input2, key_id1)

# type of join
joinType = args[3]
if (joinType == "INNER") {
  Result <- input1[input2, nomatch=0]
} else if (joinType == "LEFT") {
  Result <- merge(input1,input2, all.x=TRUE)
} else if (joinType == "RIGHT"){
  Result <- merge(input1,input2, all.y=TRUE)
} else if (joinType == "FULL"){
  Result <- merge(input1,input2, all=TRUE)
}

# write result
fwrite(Result, file = "output-join.tabular", sep = "\t", col.names = c(TRUE == args[8]))
