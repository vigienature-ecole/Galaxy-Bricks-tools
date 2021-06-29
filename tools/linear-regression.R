#!/usr/bin/env Rscript

# tool for linear regression
#
#  Input :
#     1. dataset
#     2. dependant variable
#     3. explanatory variable
#  Output :
#     1. significance
#     2. coeficients
#     3. graph

suppressPackageStartupMessages(library(ggplot2))

#get arguments from galaxy xlm command
args = commandArgs(trailingOnly=TRUE)
# args = c("tools/test-data/irisPlus.tabular", "1","2")
# args = c("tools/test-data/irisPlus.tabular", "1,3","2")
# args = c("~/Downloads/Données_INPN.csv.csv", "24","9")



# import input file (tabular or csv)
input = data.frame(data.table::fread(args[1]))


multiple = grepl(",", args[3])

# Build formula
if (multiple) {
  varExpl <- as.numeric(unlist(strsplit(args[3], ",")))
  formulaMod <- as.formula(paste(
    colnames(input)[as.numeric(args[2])],
    " ~ " ,
    paste(colnames(input)[varExpl], collapse = ' + '))
  )

} else {
  formulaMod <- as.formula(paste(colnames(input)[as.numeric(args[2])]," ~ " , colnames(input)[as.numeric(args[3])]))
}

# run linear model
res <- lm(formulaMod, data = input)

# get output from linear model
results <- summary(res)

# predict to add values to plot
trend <- predict(res, interval = "confidence")

#remove NA to predic
input <- input[!is.na(input[ , as.numeric(args[3])]) & !is.na(input[ , as.numeric(args[2])]) , ]
datlm = cbind(input, trend)

test <- function (x){
  effet = "false"
  if (x >= .05) {
    effet <- " n'a pas d'effet significatif"
  } else {
    effet <- " a un effet significatif"
  }
  effet
}

if (nrow(results[[4]]) > 1) {
  explanation <- c()
  for (i in 2:(nrow(results[[4]])))
    explanation <- c(explanation, paste0("La variable ", rownames(results[[4]])[i], test(results[[4]][i, "Pr(>|t|)"]),
                                         " sur la variable ", colnames(input)[as.numeric(args[2])]
                                         #, ". La probabilité critique est égale à ", round(results[[4]][i, "Pr(>|t|)"], 3), "."
                                         ))
  explanation <- c(explanation,
                   paste0("Le coefficient de détermination (R²) est égal à : ", round(results[[9]], 3)),
                   "Attention, ce résultat doit être vérifié.",
                   "Il peut, par exemple, être la conséquence d'un trop petit échantillon ou d'une confusion d'effet.")
  #fileConn<-file("mod-summary.txt")
  #writeLines(explanation, fileConn)
  #close(fileConn)
} else {
  # Output 1 and 2
  capture.output(results, file="mod-summary.txt")
}

if (multiple == FALSE){
  mappingCoord = ggplot2::aes_string(x = names(input)[as.numeric(args[3])],
                                     y = names(input)[as.numeric(args[2])])
  # Output 3 Graph
  # plot data
  plot_out <- ggplot2::ggplot(datlm, mappingCoord) +
    ggplot2::geom_point() +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = lwr, ymax = upr, color = NULL), alpha = .15) +
    ggplot2::geom_line(ggplot2::aes(y = fit), size = 1) +
    ggplot2::theme_minimal() +
    ggplot2::theme(axis.text = ggplot2::element_text(size=12),
                   axis.title = ggplot2::element_text(size=16),
                   strip.text.x = ggplot2::element_text(size = 14))

  plot_out <- plot_out + labs(caption = paste(explanation, collapse = "\n")) +
    theme(
      plot.caption = element_text(hjust = 1, size = 12)
    )
  suppressMessages(ggplot2::ggsave("output-plot.png", plot = plot_out, device = "png", width = 9, height = 6))
} else {
  png(filename = "output-plot.png", width = 300, height = 100)
  par(mar = c(0,0,0,0))
  plot(NA,xlim = c(0,1),ylim = c(0,1))
  text(.5,.5,"Représentation graphique impossible car\n il y a trop de variables explicatives,\n l'ensemble des résultats\n est dans le deuxième fichier")
  suppressMessages(dev.off())
}
