#!/usr/bin/env Rscript
library(data.table)
library(dplyr)
library(lubridate)

#get arguments from galaxy xlm command
args = commandArgs(trailingOnly=TRUE)
#args = c("test-data/participation-5f0490244f3219000fa1c36c-observations.csv", "data/SpeciesList.csv")

# import input file (tabular or csv)
input = data.frame(data.table::fread(args[1]))

# Import species data
correspChiro <- fread(args[2], encoding = "Latin-1")
# Remove unnecessary columns from corresp Chiro
correspChiro <- correspChiro %>%
  rename(tadarida_taxon = Esp, Nom_Scientifique = `Scientific name`,
         Nom_Espece = NomFR, Nom_Groupe = GroupFR) %>%
  select(tadarida_taxon, Nom_Scientifique, Nom_Espece, Nom_Groupe)

# Import data
dataChiro <- fread(args[1])

# Remove empty columns from data Chiro
# Remove noise from tables
# convert probabilities
dataChiro <- dataChiro %>%
  select(`nom du fichier`, temps_debut, temps_fin, tadarida_taxon, tadarida_probabilite) %>%
  filter(tadarida_taxon != "noise") %>%
  mutate(tadarida_probabilite = tadarida_probabilite * 100)


# Give species names and information about the bats
dataClean <- left_join(dataChiro, correspChiro, by="tadarida_taxon")


# extract date and time
if (substr(dataClean$`nom du fichier`[1], 28, 28) != "-"){
  add = 1
} else {
  add = 0
}
dataClean$Annee   <- substr(dataClean$`nom du fichier`, 34 + add, 37 + add)
dataClean$Mois    <- substr(dataClean$`nom du fichier`, 38 + add, 39 + add)
dataClean$Jour    <- substr(dataClean$`nom du fichier`, 40 + add, 41 + add)
dataClean$Heure   <- substr(dataClean$`nom du fichier`, 43 + add, 44 + add)
dataClean$Minute  <- substr(dataClean$`nom du fichier`, 45 + add, 46 + add)
dataClean$Seconde <- substr(dataClean$`nom du fichier`, 47 + add, 48 + add)
dataClean$Temps   <- paste(dataClean$Heure, dataClean$Minute, dataClean$Seconde, sep = ":")

# write result
fwrite(dataClean, file = "output-cleanChiroFile.csv", sep = ",")
