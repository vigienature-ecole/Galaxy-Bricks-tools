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

#get arguments from galaxy xlm command
args = commandArgs(trailingOnly=TRUE)
#args = c("tools/test-data/irisPlus.tabular", "1", "5")

# import input file (tabular or csv)
input = data.frame(data.table::fread(args[1]))

# find if there is more than one explanatory variable (separator = , )
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

# run anova
res <- aov(formulaMod, data = input)
#res <- aov(Sepal.Length ~ Species  ,data = input)

# get output from linear model
results <- summary(res)

test <- function (x){
  effet = "false"
  if (x >= .05) {
    effet <- " n'a pas d'effet significatif"
  } else {
    effet <- " a un effet significatif"
  }
  effet
}

if (nrow(results[[1]]) > 1) {
  explanation <- c()
  for (i in 1:(nrow(results[[1]]) - 1))
    explanation <- c(explanation, paste0("La variable ", rownames(results[[1]])[i], test(results[[1]]$`Pr(>F)`[i]),
                                         " sur la variable ", colnames(input)[as.numeric(args[2])],
                                         ". La probabilité critique est égale à ", round(results[[1]]$`Pr(>F)`[i], 5),"."))
  explanation <- c(explanation, "Attention, ce résultat doit être vérifié.",
                   "Il peut, par exemple, être la conséquence d'un échantillon trop petit ou biaisé ou d'une confusion d'effet.")
  fileConn<-file("mod-summary.txt")
  writeLines(explanation, fileConn)
  close(fileConn)
} else {
  # Output 1 and 2
  capture.output(results, file="mod-summary.txt")
}

if (multiple == FALSE){
  mappingCoord = ggplot2::aes_string(x = names(input)[as.numeric(args[3])],
                                     y = names(input)[as.numeric(args[2])])
  # Output 3 Graph
  # plot data
  plot_out <- ggplot2::ggplot(input, mappingCoord) +
    #ggplot2::geom_point() +
    ggplot2::geom_boxplot() +
    ggplot2::theme_minimal() +
    ggplot2::theme(axis.text = ggplot2::element_text(size=12),
                   axis.title = ggplot2::element_text(size=16),
                   strip.text.x = ggplot2::element_text(size = 14))
  suppressMessages(ggplot2::ggsave("output-plot.png", plot = plot_out, device = "png"))
}
