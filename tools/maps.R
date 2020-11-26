# carto dans galaxy

args = commandArgs(trailingOnly=TRUE)

# args = c("tools/test-data/maps-input.tab", "departements", "2", 
#          "tools/data/maps/departements-version-simplifiee.geojson",
#          "tools/data/maps/regions-version-simplifiee.geojson",
#          "tools/data/maps/metropole-version-simplifiee.geojson")

library(sf)
library(dplyr)
library(ggplot2)

# get parameters
input <- args[1]
geom <- args[2]
variable <- args[3]

#load data
data_file <- data.table::fread(input)

data_file_geo <- data_file

#verifier qu'il n'y a qu'une valeur par données sinon afficher une erreur
#charger les données de position
if (geom == "departements") {
  object_to_load =  args[4]
  data_file_geo = as.data.frame(dplyr::rename(data_file_geo, code = departements))
  data_file_geo$code <- as.character(data_file_geo$code)
} else if (geom == "regions") {
  object_to_load =  args[5]
  data_file_geo = dplyr::rename(data_file_geo, code = regions)
  data_file_geo$code <- as.character(data_file_geo$code)
} else if (geom == "points"){
  object_to_load =  args[6]
  data_file_geo <- st_as_sf(data_file_geo,coords=c("longitude", "latitude")) %>% 
    st_set_crs(4326)%>%
    st_transform(2154)
}

# import geographic data
geo = sf::read_sf(object_to_load)

# join data with geographic data
if (geom != "points") geo <- dplyr::left_join(geo, data_file_geo, by="code")
# transform to lamber 93 projection
geo <- st_transform(geo, 2154)

# add grid
g = st_graticule(geo)

png("carte.png")
par(mar = c(0,0,0,0))
# plot data
if (geom != "points"){
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
