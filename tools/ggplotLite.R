#!/usr/bin/env Rscript

# tool for data visualisation
#
#  Input :
#     1. dataset
#     2. x variable
#     3. y variable


#get arguments from galaxy xlm command
args = commandArgs(trailingOnly=TRUE)
#args <- c("tools/test-data/irisPlus.tabular", "5", "1", "NuageDePoints", "pchou", "", "tesd", "6", "5")

# import package
library(data.table) # for data import
library(ggplot2)

# import input file (tabular or csv)
input = data.frame(fread(args[1]))

type = args[4]


if (args[9] != "") facetVar = names(input)[as.numeric(args[9])] else facetVar = NULL
if (args[8] != "") colVar = names(input)[as.numeric(args[8])] else colVar = NULL

mappingCoord = ggplot2::aes_string(x = names(input)[as.numeric(args[2])],
                          y = names(input)[as.numeric(args[3])])

if (type == "NuageDePoints"){
  repType = ggplot2::geom_point(aes_string(color =  colVar))
} else if (type == "DiagrammeEnBarre"){
  repType = ggplot2::geom_col(aes_string(fill =  colVar))
} else if (type == "BoitesDeDispersion"){
  repType = ggplot2::geom_boxplot(aes_string(color =  colVar))
} else if (type == "Densite"){
  repType = ggplot2::geom_hex()
}

if (args[6] != ""){
  xlabContent = args[6]
} else {
  xlabContent = colnames(input)[as.numeric(args[2])]
}

if (args[7] != ""){
  ylabContent = args[7]
} else {
  ylabContent = colnames(input)[as.numeric(args[3])]
}


plot_out <- ggplot2::ggplot(input, mappingCoord) +
  repType +
  ggtitle(args[5]) +
  xlab(xlabContent) +
  ylab(ylabContent) +
  facet_wrap(facetVar)
  ggplot2::theme_minimal() +
  ggplot2::theme(axis.text=element_text(size=12),
                   axis.title=element_text(size=16),
                   strip.text.x = element_text(size = 14))


suppressMessages(ggplot2::ggsave("output1.png", plot = plot_out, device = "png"))
