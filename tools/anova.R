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
library(dplyr)
library(ggplot2)
library(multcomp)

#get arguments from galaxy xlm command
args = commandArgs(trailingOnly=TRUE)
#args = c("tools/test-data/irisPlus.tabular", "4", "5")

# import input file (tabular or csv)
input = data.frame(data.table::fread(args[1]))

varDepName <- colnames(input)[as.numeric(args[2])]

varExpl <- as.numeric(unlist(strsplit(args[3], ",")))
varExplNames <- colnames(input)[varExpl]

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
    summarise_at(vars(varDepName), list(mean = mean, max = max, IC = function (x) {1.96 * sd(x)/sqrt(length(x))})) %>%
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
    
  } 
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
        resTuckey <- paste(resTuckey, "Les moyennes ne sont significativement pas differente pour les catégories :", paste(names(vectorLetter[positionLetters]),"\n", collapse = ", "))
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
            plot.caption = element_text(hjust = 0, size = 12)
          )
}


plot_out <- graphRes(input, varExplNames = varExplNames, varDepName = varDepName)

suppressMessages(ggplot2::ggsave(filename = "output.png", plot = plot_out, device = "png", width = 7, height = 6))

