args = commandArgs(trailingOnly=TRUE)

# common columns VNE
column_geo <- c("code_postal_etablissement", "ville_etablissement",
                "latitude", "longitude",
                "departement", "region", "academie")

column_clc <- c("pourcentage_milieux_urbains_200m", "pourcentage_milieux_agricoles_200m",
                "pourcentage_milieux_naturels_200m", "pourcentage_milieux_urbains_5km", 
                "pourcentage_milieux_agricoles_5km", "pourcentage_milieux_naturels_5km")

column_bioclim <- c("Temperature_moyenne", "Temperature_max",
                    "Temperature_min", "Precipitation_moyenne",
                    "Precipitation_max", "Precipitation_min")

# choose between observatories
encoding = "UTF-8"
if (grepl("Vers_de_terre_VNE",args[1])){
  file <- "vdt.csv"
  column_sp <- c("numero_observation", "date_observation", "espece",                          
                 "age", "nombre_individus", "placette")
  column_zo <- c("type_de_milieu", "surface_zone",
                 "proximite_dechets_organiques", "usage_zone",
                 "fauche_tonte", "presence_paturage",
                 "utilisation_engrais", "pluie_lors_observation",
                 "vent_lors_observation", "ensoleillement_lors_observation",
                 "temperature_lors_observation", "humidite_sol_lors_observation",
                 "date_derniere_gelee", "date_derniere_pluie",
                 "difficulte_enfoncer_crayon", "taupinieres")
} else if (grepl("Oiseaux_des_jardins_VNE",args[1])){
  file <- "oiseaux.csv"
  column_sp <- c("numero_observation", "date_observation", 
                 "espece", "nombre_individus", "heure_debut")
  column_zo <- c("type_de_milieu",
                 "surface_zone", "distance_bois",
                 "distance_prairie", "distance_champ")
} else if(grepl("Operation_escargots_VNE", args[1])){
  file <- "escargots.csv"
  column_sp <- c("numero_observation", "date_observation", 
                 "espece", "nombre_individus")
  column_zo <- c("type_de_milieu",
                 "surface_zone", "distance_bois",
                 "distance_prairie", "distance_champ",
                 "utilisation_pesticide",
                 "surface_planche")
} else if(grepl("Sauvages_de_ma_rue_VNE", args[1])){
  file <- "sauvages.csv"
  column_sp <- c("numero_observation", "date_observation", 
                 "espece")
  column_zo <- c("longueur_rue", "latitude_debut",
                 "longitude_debut","latitude_fin",
                 "longitude_fin","cote_rue")
  column_geo <- c("code_postal_etablissement", "ville_etablissement",
                  "departement", "region", "academie")
} else if(grepl("Spipoll", args[1])){
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

if (grepl("_clc",args[1])){
  select_column <- c(column_sp, column_clc, column_geo)
  data_VNE_selected <- data_VNE[, ..select_column]
} else if  (grepl("_zo",args[1])){
  select_column <- c(column_sp, column_zo, column_geo)
  data_VNE_selected <- data_VNE[, ..select_column]
} else if  (grepl("_bioclim",args[1])){
  select_column <- c(column_sp, column_bioclim, column_geo)
  data_VNE_selected <- data_VNE[, ..select_column]
} else if (args[1] == "INPN"){
  data_VNE_selected <- data_VNE[ , c(
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
} else if (args[1] == "Spipoll") {
  data_VNE_selected <- subset(data_VNE, data_VNE$Temperature != "")
} else {
  data_VNE_selected = data_VNE
}

# write file
write.csv(data_VNE_selected, "output-importVNE.csv", row.names = FALSE)



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
