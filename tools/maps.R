# carto dans galaxy

args = commandArgs(trailingOnly=TRUE)

# args = c("../../../Downloads/compte sur la colonne 2 en fonction de la colonne 9.csv.csv",
#          "1", 
#          "departements", 
#          "2", 
#          "data/maps/departements-version-simplifiee.geojson",
#          "data/maps/regions-version-simplifiee.geojson",
#          "data/maps/metropole-version-simplifiee.geojson",
#          "data/maps/correspondance_departement_region.csv")

library(sf)
library(dplyr)
library(ggplot2)

# get parameters
input <- args[1]
geographic_data <- as.numeric(args[2])
geographic_scale <- args[3]
variable <- as.numeric(args[4])
correspondance_departement_region <- args[8]

#load data
data_file <- data.table::fread(input)
# remove spaces
colnames(data_file)[variable] <- stringr::str_replace_all(colnames(data_file)[variable], " ", "_")


correspondance_departement_region_df <- data.table::fread(correspondance_departement_region)


data_file_geo <- data_file
data_file_geo[[geographic_data]] <- substring(as.vector(data_file_geo[[geographic_data]]), 0, 2)


#TODO : verifier qu'il n'y a qu'une valeur par données sinon afficher une erreur
#charger les données de position
if (geographic_scale == "departements") {
  colnames(data_file_geo)[geographic_data] <- "code"
  data_file_geo$code <- as.character(data_file_geo$code)
  geographic_scale_to_load =  args[5]
} else if (geographic_scale == "regions") {
  colnames(data_file_geo)[geographic_data] <- "code"
  data_file_geo$code <- as.character(data_file_geo$code)
  data_file_geo <- dplyr::left_join( data_file_geo, correspondance_departement_region_df, by=c("code" = "code_departement"))
  data_file_geo <- data_file_geo[, -"code"]
  colnames(data_file_geo)[which(colnames(data_file_geo) == "code_region")] <- "code"
  data_file_geo$code <- as.character(data_file_geo$code)
  geographic_scale_to_load =  args[6]
} else if (geographic_scale == "points"){
  geographic_scale_to_load =  args[7]
  data_file_geo <- st_as_sf(data_file_geo,coords=c("longitude", "latitude")) %>% 
    st_set_crs(4326)%>%
    st_transform(2154)
}

# import geographic data
geo = sf::read_sf(geographic_scale_to_load)

# join data with geographic data
if (geographic_scale != "points") {
  geo <- dplyr::left_join(geo, data_file_geo, by="code")
}
# transform to lamber 93 projection
geo <- st_transform(geo, 2154)

# add grid
g = st_graticule(geo)



png("carte.png", width = 800, height = 800)
par(mar = c(0,0,0,0))
# plot data
if (geographic_scale != "points"){
  ggplot(geo, aes_string(fill = colnames(data_file_geo)[variable])) +
    geom_sf(data = geo)+
    theme_bw()                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
} else {
  ggplot(geo)+
    geom_sf(data = geo)+
    geom_sf(data = data_file_geo)+
    theme_bw()
}
dev.off()
