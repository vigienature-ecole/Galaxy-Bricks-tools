#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)

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
con <- dbConnect(drv, dbname = "VNE4",
                 host = "vm-dev-php7-00.starcrags.com", port = 5432,
                 user = "vne4-public", password = "vne4@passwd")
  on.exit(dbDisconnect(con))
if (args[1] == "Vers_de_terre"){
  query <- getSQL(args[2])
} else if (args[1] == "Oiseaux_des_jardins"){
  query <- getSQL(args[3])
} else if(args[1] == "Operation_escargot"){
  query <- getSQL(args[4])
} else if(args[1] == "Sauvage_de_ma_rue"){
  query <- getSQL(args[5])
}

#get result from query
df_VNE <- dbGetQuery(con, query)
if ("composition_zone" %in% colnames(df_VNE))
  df_VNE$composition_zone <- str_replace_all(df_VNE$composition_zone, ",", "-")

# close the connection
dbDisconnect(con)
dbUnloadDriver(drv)

# write file
write.csv(df_VNE, "output-importVNE.csv", row.names = FALSE)
