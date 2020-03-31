#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)

#args <- c("Vers_de_terre", "tools/query/RequeteVdtVNE4.sql")

# import package
require(RPostgreSQL, quietly = TRUE)
library(stringr, quietly = TRUE)
library(dplyr, quietly = TRUE, warn.conflicts = FALSE)

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
} else if(args[1] == "Operation_escargot"){
  query <- getSQL(args[4])
} else if(args[1] == "Sauvage_de_ma_rue"){
  query <- getSQL(args[5])
} else if (args[1] == "Vers_de_terre_VNE2"){
  query <- getSQL(args[6])
} else if (args[1] == "Oiseaux_des_jardins_VNE2"){
  query <- getSQL(args[7])
} else if(args[1] == "Operation_escargot_VNE2"){
  query <- getSQL(args[8])
} else if(args[1] == "Sauvage_de_ma_rue_VNE2"){
  query <- getSQL(args[9])
}

#get result from query
df_VNE <- dbGetQuery(con, query)
if (args[1] == "Operation_escargot") df_VNE <- na.omit(df_VNE)
if ("composition_zone" %in% colnames(df_VNE))
  df_VNE$composition_zone <- str_replace_all(df_VNE$composition_zone, ",", "-")
if ("difficulte_enfoncer_crayon" %in% colnames(df_VNE))
  df_VNE <- mutate(df_VNE, difficulte_enfoncer_crayon = recode(difficulte_enfoncer_crayon,
                        tres_facile = "01_tres_facile",
                        facile = "02_facile",
                        peu_difficile = "03_peu_difficile",
                        difficile = "04_difficile"))

# close the connection
dbDisconnect(con)
dbUnloadDriver(drv)

# write file
write.csv(df_VNE, "output-importVNE.csv", row.names = FALSE)
