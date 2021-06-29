#!/usr/bin/env Rscript

# tools to filter specific column

#get arguments from galaxy xlm command
args = commandArgs(trailingOnly=TRUE)
#args = c("tools/test-data/irisPlus.tabular", "garder", "6", "superieuresOuEgalesA", "laColonne", "1")
#args = c("~/Downloads/VigieNature-Ecole_Especes_Occ.csv", "garder", "166", "superieuresOuEgalesA", "laColonne", "2")
#args = c("~/Downloads/VigieNature-Ecole_Especes_Occ.csv", "supprimer", "166", "inferieuresOuEgalesA", "laColonne", "2")


# import package
suppressPackageStartupMessages(library(data.table)) # for data import
suppressPackageStartupMessages(library(stringr)) # to work with string
suppressPackageStartupMessages(library(dplyr))


# parameters translated
# add numeric / not numeric
negateMatching = args[2]
filterParameter = args[3]
filterType = args[4]
wholeLine = args[5]
columnsNumber = as.numeric(args[6])

#filterParameter = "é"
#print(filterParameter)

# import input file (tabular or csv)
input = data.frame(fread(args[1], encoding = "UTF-8"))




#select lines
if (wholeLine == "laColonne"){
  if (negateMatching == "garder"){
    if(filterType == "egaleA"){
      result <- dplyr::filter(input, str_detect(input[ ,columnsNumber], regex(filterParameter, ignore_case = TRUE)))
    } else if (filterType == "exactementEgaleA"){
      result <- dplyr::filter(input, input[ ,columnsNumber] == filterParameter)
    } else if (filterType == "superieuresOuEgalesA"){
      result <- dplyr::filter(input, input[ ,columnsNumber] >= as.numeric(filterParameter))
    } else if (filterType == "inferieuresOuEgalesA"){
      result <- dplyr::filter(input, input[ ,columnsNumber] <= as.numeric(filterParameter))
    }
  } else {
    if(filterType == "egaleA"){
      result <- dplyr::filter(input, !str_detect(input[ ,columnsNumber], regex(filterParameter, ignore_case = TRUE)))
    } else if (filterType == "exactementEgaleA"){
      result <- dplyr::filter(input, !input[ ,columnsNumber] == filterParameter)
    } else if (filterType == "superieuresOuEgalesA"){
      result <- dplyr::filter(input, !input[ ,columnsNumber] >= as.numeric(filterParameter))
    } else if (filterType == "inferieuresOuEgalesA"){
      result <- dplyr::filter(input, !input[ ,columnsNumber] <= as.numeric(filterParameter))
    }
  }
} else {
  if (negateMatching == "garder"){
    result <- dplyr::filter_all(input, any_vars(str_detect(., filterParameter)))
  } else {
    result <- input[apply(input, 1, function (x) !any(str_detect(x, filterParameter))), ]
  }
}
#write file
fwrite(result, "output-filter.csv", sep =",")
