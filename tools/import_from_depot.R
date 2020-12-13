args = commandArgs(trailingOnly=TRUE)

#args <- c("Oiseaux_des_jardins", "tools/query/RequeteVdtVNE4.sql", "tools/query/RequeteOiseauxVNE4.sql", "tools/query/RequeteEscargotsVNE4.sql", "tools/query/RequeteSauvagesVNE4.sql")
#args <- c("Operation_escargots", "tools/query/RequeteVdtVNE4.sql", "tools/query/RequeteOiseauxVNE4.sql", "tools/query/RequeteEscargotsVNE4.sql", "tools/query/RequeteSauvagesVNE4.sql")

#args <- c("Oiseaux_des_jardins")
#args <- c("Vers_de_terre")
#args <- c("Operation_escargots")
#args <- c("Sauvages_de_ma_rue")
#args <- c("INPN")


if (args[1] == "Vers_de_terre"){
  file <- "vdt.csv"
} else if (args[1] == "Oiseaux_des_jardins"){
  file <- "oiseaux.csv"
} else if(args[1] == "Operation_escargots"){
  file <- "escargots.csv"
} else if(args[1] == "Sauvages_de_ma_rue"){
  file <- "sauvages.csv"
} else if (args[1] == "INPN"){
  file <- "INPN.csv"
}

URL_data_VNE <- RCurl::getURL(paste0("https://depot.vigienature-ecole.fr/datasets/bricks/", file), .encoding = "UTF-8")
data_VNE <- read.csv(text = URL_data_VNE, encoding = 'UTF-8')

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

# if (args[1] == "Sauvages_de_ma_rue"){
#   #   cleaned_df <- data_VNE[!is.na(data_VNE$environnement), ]
#   #   parsedCol <- parseJSONLabelValue(cleaned_df, "environnement")
#   #   data_VNE <- dplyr::bind_cols(cleaned_df, parsedCol)
#   data_VNE$environnement <- NULL
# }



# if (args[1] == "Operation_escargots") data_VNE <- na.omit(data_VNE)
# if ("composition_zone" %in% colnames(data_VNE)){
#   # lecture du JSON
#   
#   compositionData_num <- parseJSONLabelValue(data_VNE, "composition_zone")
#   
#   # listes
#   artif <- c(
#     "Haie de laurier",
#     "Plantes aromatiques (thym, romarin, basilic...)",
#     "Pelouse tondue",
#     "Parterre et arbustes fleuris",
#     "Espaces pavés, gravillonnés",
#     "Potager",
#     "Verger, arbres fruitiers|Verger, arbres fruitiers",
#     "Géraniums et pélargoniums",
#     "Lavande",
#     "Haies (sauf thuyas ou laurier cerise)"
#   )
#   
#   spontane <- c(
#     "Trèfles, lotiers et luzernes",
#     "Orties",
#     "Ronces",
#     "Lierre",
#     "Pelouse tondue",
#     "Espaces non entretenus (friches, espaces naturels)"
#   )
#   
#   naturalite <- c(
#     "Orties",
#     "Ronces",
#     "Lierre",
#     "Espaces non entretenus (friches, espaces naturels)"
#   )
#   
#   data_VNE$elements_artificiels <- rowSums(compositionData_num[ , artif])
#   data_VNE$elements_spontanes <- rowSums(compositionData_num[ , spontane])
#   data_VNE$naturalite <- rowSums(compositionData_num[ , naturalite])
#   
#   data_VNE$composition_zone <- NULL
# }

# write file
write.csv(data_VNE, "output-importVNE.csv", row.names = FALSE)

