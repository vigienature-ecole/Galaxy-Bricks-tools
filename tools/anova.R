#!/usr/bin/env Rscript

# tool for anova analysis
#
#  Input :
#     1. dataset
#     2. dependant variable
#     3. explanatory variable (can be more than one)
#  Output :
#     1. significance
#     2. coeficients
#     3. graph

#import package
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(multcomp))

#get arguments from galaxy xlm command
args = commandArgs(trailingOnly=TRUE)
# args = c("tools/test-data/irisPlus.tabular", "4", "5")
# args = c("../../Downloads/Résumer des données on data 1.csv", "3", "2")
# args = c("../../Downloads/Données_INPN.csv.csv", "24", "17")
# args = c("../../Downloads/somme sur la colonne 11 en fonction de la colonne 1,10,12.csv(1).csv", "4", "3,2")

# import input file (tabular or csv)
input = data.frame(data.table::fread(args[1]))




varDepName <- colnames(input)[as.numeric(args[2])]

varExpl <- as.numeric(unlist(strsplit(args[3], ",")))
varExplNames <- colnames(input)[varExpl]

verif_input <- input %>%
  group_by_at(varExplNames) %>%
  summarize(nombre = n())

if(all(verif_input$nombre <= 1)) stop("Le fichier ne contient qu'une seule valeur pour chaque catégorie. Il faut choisir le fichier de données brutes.")

# clean dataset
for (i in seq_along(varExplNames)){
  input = input[!input[ ,varExplNames[i]] == "", ]
  input = input[!is.na(input[ ,varExplNames[i]]), ]
}

# transform value to factors
input[varExplNames] <- lapply(input[varExplNames], factor)

# find if there is more than one explanatory variable (separator = , )
multiple = grepl(",", args[3])



myglht <- function (res = NULL, fact = NULL) {
  glht(res,
       linfct = do.call(mcp, setNames(list("Tukey"), fact))
  )
}

graphRes <- function(input, varExplNames, varDepName){
  
  if (!multiple){
    levelNames <- unique(input[ , varExplNames])
    if (length(levelNames) > 2){
      levelNamesFormated <- paste(paste(levelNames[-length(levelNames)], collapse = ", "), levelNames[length(levelNames)], sep = " et ")
    } else {
      levelNamesFormated <-paste(levelNames, collapse = " et ")
    }
  }
  
  # Build formula
  if (multiple) {
    formulaMod <- as.formula(paste(
      varDepName,
      " ~ " ,
      paste(varExplNames, collapse = ' + '))
    )
    
  } else {
    formulaMod <- as.formula(paste(varDepName," ~ " , varExplNames))
  }
  
  # run anova
  res <- aov(formulaMod, data = input)
  
  # get output from linear model
  results <- summary(res)
  
  # Prepare Graph
  indicateurMeanMax <- input %>%
    group_by_at(varExplNames) %>%
    summarise_at(vars(varDepName), list(mean = function(x) mean(x, na.rm = TRUE), 
                                        max = function(x) max(x, na.rm = TRUE), 
                                        IC = function (x) {1.96 * sd(x, na.rm = TRUE)/sqrt(length(na.omit(x)))})) %>%
    mutate(ICmin = mean - IC,
           ICmax = mean + IC)
  
  if (length(varExplNames) == 1){ # anova a un facteur et t.test a implementer
    postHocs <- myglht(res = res, fact = varExplNames)
    lettersGroupOutput <- cld(postHocs)
    vectorLetter <- lettersGroupOutput$mcletters$Letters
    
    plot <- ggplot(indicateurMeanMax, aes_string(x = varExplNames, y = "mean")) +
      geom_point() +
      geom_errorbar(aes(ymin = ICmin, ymax = ICmax), width = .2)+
      theme_minimal() +
      theme(legend.position = "none") +
      theme(axis.text.x=element_text(angle = 35, hjust = 1))+
      ylab(varDepName)
    
    plot <- plot + annotate("text", 
                            x = names(vectorLetter), 
                            y = max(indicateurMeanMax$ICmax) + .1 * (max(indicateurMeanMax$ICmax) - min(min(indicateurMeanMax$ICmin))), 
                            label = vectorLetter)
    
    
    # traduction
    
    letterGroup <- unique(unlist(strsplit(as.character(vectorLetter), "")))
    resTuckey = "Résultat du test statistique : \n \n"
    
    if (results[[1]]$`Pr(>F)`[1] > 0.05){
      resTuckey <- paste(resTuckey, "La variable ", varExplNames, " n'a pas d'effet significatif sur la variable ", varDepName,". \n \n", "Les catégories ", levelNamesFormated, " ne sont pas significativement différentes.", sep = "")
    } else {
      resTuckey <- paste(resTuckey, "La variable ", varExplNames, " a un effet significatif sur la variable ", varDepName," \n \n", sep = "")
      
      for (i in 1:length(letterGroup)){
        positionLetters = grep(pattern = letterGroup[i], vectorLetter)
        if (length(positionLetters) > 1){
          resTuckey <- paste(resTuckey, "Les moyennes ne sont significativement pas différente pour les catégories :", paste(names(vectorLetter[positionLetters]),"\n", collapse = ", "))
        } else {
          resTuckey <- paste(resTuckey, "La catégorie", names(vectorLetter[positionLetters]), "est significativement différente de toutes les autres \n")
        }
      }
      #add warning if a variable is in more than one group
      # get variables in 2 groups
      variablesInTwoGroups <- which(nchar(as.character(vectorLetter))>1)
      if (length(variablesInTwoGroups) > 1){
        print(paste("Attention les catégories :", names(vectorLetter[variablesInTwoGroups]), "sont présentes dans plusieurs groupes"))
      } else if (length(variablesInTwoGroups) == 1){
        print(paste("Attention la catégorie :", names(vectorLetter[variablesInTwoGroups]), "est présente dans plusieurs groupes"))
      }
    }
    
    plot + labs(caption = resTuckey) + 
      theme(
        plot.caption = element_text(hjust = 1, size = 12)
      )
    
  } else if (length(varExplNames) == 2){
    plot <- ggplot(indicateurMeanMax, aes_string(x = varExplNames[1], y = "mean")) +
      geom_point() +
      geom_errorbar(aes(ymin = ICmin, ymax = ICmax), width = .2) +
      facet_grid(as.formula(paste("~", varExplNames[2]))) +
      theme_minimal() +
      theme(legend.position = "none") +
      theme(axis.text.x=element_text(angle = 35, hjust = 1))+
      ylab(varDepName)
    
    
    resMultiple = "Résultat du test statistique : \n \n"
    
    for (i in 1:2){
      if (results[[1]]$`Pr(>F)`[i] > 0.05){
        levelNamesFormated <- unique(input[, varExplNames[i]])
        resMultiple <- paste(resMultiple, "La variable ", row.names(results[[1]])[i], " n'a pas d'effet significatif sur la variable ", varDepName,". \n ", "Les catégories ", levelNamesFormated, " ne sont pas significativement différentes.\n \n", sep = "")
      } else {
        levelNamesFormated <- unique(input[, varExplNames[i]])
        resMultiple <- paste(resMultiple, "La variable ", varExplNames[i], " a un effet significatif sur la variable ", varDepName," \n ", "Au moins une des catégories est significativement différente des autres.\n \n", sep = "")
      }
    }
    plot + labs(caption = resMultiple) + 
      theme(
        plot.caption = element_text(hjust = 1, size = 12)
      )
  } else {
    stop("Il ne peut pas y avoir plus de 2 varibles explicatives pour le moment")
  }
  
}


plot_out <- graphRes(input, varExplNames = varExplNames, varDepName = varDepName)

suppressMessages(ggplot2::ggsave(filename = "output.png", plot = plot_out, device = "png", width = 9, height = 6))

