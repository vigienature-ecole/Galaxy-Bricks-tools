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

mappingCoord = aes_string(x = names(input)[as.numeric(args[2])],
                          y = names(input)[as.numeric(args[3])])

if (type == "point"){
  repType = geom_point()
} else if (type == "bar"){
  repType = geom_bar()
} else if (type == "boxplot"){
  repType = geom_boxplot()
}

plot_out <- ggplot(input, mappingCoord) +
  repType

ggsave("output1.png", plot = plot_out, device = "png")
