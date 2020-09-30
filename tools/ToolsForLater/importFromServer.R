#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)
#args = "Oiseaux_des_jardins"

options(RCurlOptions = list(ssl.verifypeer = FALSE))
#import file from server

if (args[1] == "Oiseaux_des_jardins") {
  protocoleFile = "Oiseaux_des_jardins.csv"
} else if (args[1] == "Sauvages_de_ma_rue"){
  protocoleFile = "Sauvages_de_ma_rue.csv"
} else if (args[1] == "Operation_escargots"){
  protocoleFile = "Operation_escargots.csv"
} else if (args[1] == "Vers_de_terre"){
  protocoleFile = "Vers_de_terre.csv"
}

URLDataVNE <- RCurl::getURL(paste0("https://www.vigienature-ecole.fr/sites/www.vigienature-ecole.fr/files/upload/Datasets/", protocoleFile))

df_VNE <- read.csv (text = URLDataVNE, sep = ",", encoding = "UTF-8")

#write file
write.csv(df_VNE, "output-importVNE.csv", row.names = FALSE)
