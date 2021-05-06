# carto dans galaxy

library(sf)
library(dplyr)
library(ggplot2)

args = commandArgs(trailingOnly=TRUE)

# args = c("test-data/input_depart_pas_complet.csv",
#          "departements",
#          "1",
#          "2",
#          "data/maps/departements-version-simplifiee.geojson",
#          "data/maps/regions-version-simplifiee.geojson",
#          "data/maps/academies-version-simplifiee.geojson"
# )

# args = c("~/github/Requetes-et-restitutions/R-pour-restitutions/import_add_data/bricks/DataINPN.csv",
#          "maillesINPN",
#          "1",
#          "14",
#          "data/maps/departements-version-simplifiee.geojson",
#          "data/maps/regions-version-simplifiee.geojson",
#          "data/maps/academies-version-simplifiee.geojson",
#          "data/maps/maille10km.geojson"
# )
# args = c('~/github/Requetes-et-restitutions/R-pour-restitutions/import_add_data/bricks/DataINPN.csv',
#          'maillesINPN',
#          '1',
#          '14',
#          'data/maps/departements-version-simplifiee.geojson',
#          'data/maps/regions-version-simplifiee.geojson',
#          'data/maps/metropole-version-simplifiee.geojson',
#          'data/maps/academies-version-simplifiee.geojson',
#          'data/maps/data/maps/maille10km.geojson'
# )





# get parameters
input <- args[1]
geographic_scale <- args[2]
geographic_data <- as.numeric(args[3])
variable <- as.numeric(args[4])

#load data
data_file <- data.frame(data.table::fread(input))

# remove spaces
colnames(data_file)[variable] <- gsub(" ", "_", colnames(data_file)[variable])
# convert to characters
data_file [ , geographic_data] <- as.character(data_file [ , geographic_data])

data_file_geo <- data_file


# add 0 to departement where they are missing
short_values <- nchar(as.vector(data_file_geo[[geographic_data]])) < 2
any(short_values)
if (any(short_values) & geographic_scale != "academies") {
  data_file_geo[[geographic_data]][short_values] <- paste0("0", as.vector(data_file_geo[[geographic_data]])[short_values])
}

if (any(data_file_geo[[geographic_data]] > 5)) {
  name = TRUE
} else {
  name = FALSE
}

if (geographic_scale != "points") {
  if (name) {
    colnames(data_file_geo)[geographic_data] <- "nom"
    data_file_geo$nom <- as.character(data_file_geo$nom)
  } else {
    colnames(data_file_geo)[geographic_data] <- "code"
    data_file_geo$code <- as.character(data_file_geo$code)
  }
}

#TODO : verifier qu'il n'y a qu'une valeur par données sinon afficher une erreur
#charger les données de position
if (geographic_scale == "departements") {
  geographic_scale_to_load = args[5]
} else if (geographic_scale == "regions") {
  geographic_scale_to_load =  args[6]
} else if (geographic_scale == "academies") {
  geographic_scale_to_load =  args[8]
} else if (geographic_scale == "maillesINPN") {
  geographic_scale_to_load =  args[9]
} else if (geographic_scale == "points") {
  geographic_scale_to_load =  args[7]
  data_file_geo <- st_as_sf(data_file_geo,coords=c("longitude", "latitude")) %>%
    st_set_crs(4326)%>%
    st_transform(2154)
}

# import geographic data
geo = sf::read_sf(geographic_scale_to_load)

# join data with geographic data
print(geographic_scale)

print("geo")
print(colnames(geo))
print("geo_file")
print(colnames(data_file_geo))



if (geographic_scale == "maillesINPN") {
  print(c(colnames(geo), colnames(data_file_geo)))
  geo <- dplyr::inner_join(geo, data_file_geo, by=c("CD_SIG" = "code")) %>%
    st_set_crs(2154)
  print("ok")
} else if (geographic_scale != "points") {
  if (name) {
    geo <- dplyr::left_join(geo, data_file_geo, by="nom") %>%
      st_transform(2154)
  } else {
    geo <- dplyr::left_join(geo, data_file_geo, by="code") %>%
      st_transform(2154)
  }
}

# add grid
g = st_graticule(geo)

png("carte.png", width = 800, height = 800)
par(mar = c(0,0,0,0))
# plot data
if (geographic_scale == "maillesINPN") {
  ggplot(geo, aes_string(fill = colnames(data_file_geo)[variable])) +
    geom_sf(data = geo, lwd = 0) +
    theme_bw()
} else if (geographic_scale != "points") {
  ggplot(geo, aes_string(fill = colnames(data_file_geo)[variable])) +
    geom_sf(data = geo) +
    theme_bw()
} else {
  ggplot(geo) +
    geom_sf(data = geo) +
    geom_sf(data = data_file_geo) +
    theme_bw()
}
dev.off()

