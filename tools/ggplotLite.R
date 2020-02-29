#!/usr/bin/env Rscript

# tool for data visualisation
#
#  Input :
#     1. dataset
#     2. x variable
#     3. y variable


#get arguments from galaxy xlm command
args = commandArgs(trailingOnly=TRUE)

# import package
library(data.table) # for data import
library(ggplot2)

# import input file (tabular or csv)
input = data.frame(fread(args[1]))

type = args[4]

mappingCoord = ggplot2::aes_string(x = names(input)[as.numeric(args[2])],
                          y = names(input)[as.numeric(args[3])])

if (type == "NuageDePoints"){
  repType = ggplot2::geom_point()
} else if (type == "DiagrammeEnBarre"){
  repType = ggplot2::geom_col()
} else if (type == "BoitesDeDispersion"){
  repType = ggplot2::geom_boxplot()
} else if (type == "Densite"){
  repType = ggplot2::geom_hex()
}

plot_out <- ggplot2::ggplot(input, mappingCoord) +
  repType +
  ggplot2::theme_minimal() +
  ggplot2::theme(axis.text=element_text(size=12),
                   axis.title=element_text(size=16),
                   strip.text.x = element_text(size = 14))


suppressMessages(ggplot2::ggsave("output1.png", plot = plot_out, device = "png"))
