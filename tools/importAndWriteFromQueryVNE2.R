#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)

#args <- c("Oiseaux_des_jardins", "tools/query/RequeteVdtVNE4.sql", "tools/query/RequeteOiseauxVNE4.sql", "tools/query/RequeteEscargotsVNE4.sql", "tools/query/RequeteSauvagesVNE4.sql")
#args <- c("Operation_escargots", "tools/query/RequeteVdtVNE4.sql", "tools/query/RequeteOiseauxVNE4.sql", "tools/query/RequeteEscargotsVNE4.sql", "tools/query/RequeteSauvagesVNE4.sql")


# import package
require(RPostgreSQL, quietly = TRUE)
library(stringr, quietly = TRUE)
library(dplyr, quietly = TRUE, warn.conflicts = FALSE)
library(jsonlite)

# fonction for restitution

# https://stackoverflow.com/questions/44853322/how-to-read-the-contents-of-an-sql-file-into-an-r-script-to-run-a-query
getSQL <- function(filepath){
  con = file(filepath, "r")
  sql.string <- ""
  
  while (TRUE){
    line <- readLines(con, n = 1)
    
    if ( length(line) == 0 ){
      break
    }
    
    line <- gsub("\\t", " ", line)
    
    if(grepl("--",line) == TRUE){
      line <- paste(sub("--","/*",line),"*/")
    }
    
    sql.string <- paste(sql.string, line)
  }
  
  close(con)
  return(sql.string)
}


# loads the PostgreSQL driver
drv <- dbDriver("PostgreSQL")
# creates a connection to the postgres database
# note that "con" will be used later in each connection to the database
if (length(grep("_VNE2", args[1]))>0){
  con <- dbConnect(drv, dbname = "VNE2",
                   host = "harmonica.semi-k.net", port = 5432,
                   user = "vne2_ls", password = "_v1g1eN4tuR3_")
} else {
  con <- dbConnect(drv, dbname = "VNE4",
                   host = "vm-dev-php7-00.starcrags.com", port = 5432,
                   user = "vne4-public", password = "vne4@passwd")
}

if (args[1] == "Vers_de_terre"){
  query <- getSQL(args[2])
} else if (args[1] == "Oiseaux_des_jardins"){
  query <- getSQL(args[3])
} else if(args[1] == "Operation_escargots"){
  query <- getSQL(args[4])
} else if(args[1] == "Sauvages_de_ma_rue"){
  query <- getSQL(args[5])
} else if (args[1] == "Vers_de_terre_VNE2"){
  query <- getSQL(args[6])
} else if (args[1] == "Oiseaux_des_jardins_VNE2"){
  query <- getSQL(args[7])
} else if(args[1] == "Operation_escargots_VNE2"){
  query <- getSQL(args[8])
} else if(args[1] == "Sauvages_de_ma_rue_VNE2"){
  query <- getSQL(args[9])
}

#get result from query
df_VNE <- dbGetQuery(con, query)


parseJSONLabelValue <- function (df, var) {
  # parse JSON
  parsedData <- jsonlite::stream_in(textConnection(df[ , var]))
  # get data.frame
  flattenData <- jsonlite::flatten(parsedData)
  # donner les bons noms de champs
  colnames(flattenData)[seq(2, ncol(flattenData), 2)] <- flattenData[1, seq(1, ncol(flattenData) - 1, 2)]
  # selectionner les colonnes
  flattenData <- flattenData[ , seq(2, ncol(flattenData), 2)]
  # passer les TRUE FALSE en 0 1
  flattenData <- sapply(flattenData, as.numeric)
  as.data.frame(flattenData)
}

if (args[1] == "Sauvages_de_ma_rue"){
  #   cleaned_df <- df_VNE[!is.na(df_VNE$environnement), ]
  #   parsedCol <- parseJSONLabelValue(cleaned_df, "environnement")
  #   df_VNE <- dplyr::bind_cols(cleaned_df, parsedCol)
  df_VNE$environnement <- NULL
}



if (args[1] == "Operation_escargots") df_VNE <- na.omit(df_VNE)
if ("composition_zone" %in% colnames(df_VNE)){
  # lecture du JSON
  
  compositionData_num <- parseJSONLabelValue(df_VNE, "composition_zone")
  
  # listes
  artif <- c(
    "Haie de laurier",
    "Plantes aromatiques (thym, romarin, basilic...)",
    "Pelouse tondue",
    "Parterre et arbustes fleuris",
    "Espaces pavés, gravillonnés",
    "Potager",
    "Verger, arbres fruitiers|Verger, arbres fruitiers",
    "Géraniums et pélargoniums",
    "Lavande",
    "Haies (sauf thuyas ou laurier cerise)"
  )
  
  spontane <- c(
    "Trèfles, lotiers et luzernes",
    "Orties",
    "Ronces",
    "Lierre",
    "Pelouse tondue",
    "Espaces non entretenus (friches, espaces naturels)"
  )
  
  naturalite <- c(
    "Orties",
    "Ronces",
    "Lierre",
    "Espaces non entretenus (friches, espaces naturels)"
  )
  
  df_VNE$elements_artificiels <- rowSums(compositionData_num[ , artif])
  df_VNE$elements_spontanes <- rowSums(compositionData_num[ , spontane])
  df_VNE$naturalite <- rowSums(compositionData_num[ , naturalite])
  
  df_VNE$composition_zone <- NULL
}



# close the connection
dbDisconnect(con)
dbUnloadDriver(drv)

# write file
write.csv(df_VNE, "output-importVNE.csv", row.names = FALSE)
