args = commandArgs(trailingOnly=TRUE)

# choose between observatories
encoding = "UTF-8"
if (args[1] == "Vers_de_terre"){
  file <- "vdt.csv"
} else if (args[1] == "Oiseaux_des_jardins"){
  file <- "oiseaux.csv"
} else if(args[1] == "Operation_escargots"){
  file <- "escargots.csv"
} else if(args[1] == "Sauvages_de_ma_rue"){
  file <- "sauvages.csv"
} else if(args[1] == "Spipoll"){
  file <- "spipoll.csv"
  encoding = "Latin-1"
} else if (args[1] == "INPN"){
  file <- "DataINPN.csv"
} else if (args[1] == "INPN_Gasteropodes"){
  file <- "Gasteropodes.csv"
} else if (args[1] == "INPN_Rhopaloceres"){
  file <- "Rhopaloceres.csv"
}

# get data set

URL_data_VNE <- RCurl::getURL(paste0("https://depot.vigienature-ecole.fr/datasets/bricks/", file), 
                              .encoding = "UTF-8")
data_VNE <- data.table::fread(text = URL_data_VNE, fill = TRUE, encoding = encoding)

if (args[1] == "INPN" & args[2] != "saisons"){
  data_VNE <- data_VNE[ , c(
    "Identifiant_de_la_zone_geographique",
    "Departement",
    "Region",
    "Temperature_moyenne_annuelle",
    "Precipitations_maximales",
    "Milieu_majoritaire",
    "Pourcentage_milieux_urbanises",
    "Pourcentage_milieux_agricoles",
    "Pourcentage_milieux_ouverts_type_prairie",
    "Pourcentage_milieux_forestiers",
    #Types_arbres_majoritaires,
    "Population_de_la_zone",
    "Pourcentage_aires_protegees",
    "Indice_utilisation_pesticides",
    "Nombre_especes",
    "Nombre_especes_menacees",
    "Nombre_especes_presentes_quasi_exclusivement_en_France",
    "Nombre_especes_insectes",
    "Nombre_especes_reptiles",
    "Nombre_especes_escargots",
    #Nombre_especes_escargots_ete,
    #Nombre_especes_escargots_hiver,
    "Nombre_especes_plantes_a_fleurs",
    "Nombre_especes_papillons"
    #Nombre_especes_papillons_ete,
    #Nombre_especes_papillons_hiver
  )]
} else if (args[1] == "Spipol") {
  data_VNE <- data_VNE %>%
    filter(temperature != "")
}

# write file
write.csv(data_VNE, "output-importVNE.csv", row.names = FALSE)



# parseJSONLabelValue <- function (df, var) {
#   # parse JSON
#   parsedData <- jsonlite::stream_in(textConnection(df[ , var]))
#   # get data.frame
#   flattenData <- jsonlite::flatten(parsedData)
#   # donner les bons noms de champs
#   colnames(flattenData)[seq(2, ncol(flattenData), 2)] <- flattenData[1, seq(1, ncol(flattenData) - 1, 2)]
#   # selectionner les colonnes
#   flattenData <- flattenData[ , seq(2, ncol(flattenData), 2)]
#   # passer les TRUE FALSE en 0 1
#   flattenData <- sapply(flattenData, as.numeric)
#   as.data.frame(flattenData)
# }

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
