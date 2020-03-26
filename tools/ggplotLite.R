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
#args <- c("tools/test-data/irisPlus.tabular",'1', '2', 'LigneEtPoints', 'DiversitX en fonction de l__sq__environnement', 'Environnement', 'DiversitX moyenne', 'None', 'None')

# import package
library(data.table) # for data import
library(ggplot2)

# import input file (tabular or csv)
input = data.frame(fread(args[1]))

type = args[4]



if (args[8] != "None") colVar = names(input)[as.numeric(args[8])] else colVar = NULL

mappingCoord = ggplot2::aes_string(x = names(input)[as.numeric(args[2])],
                                   y = names(input)[as.numeric(args[3])])

plot_out <- ggplot2::ggplot(input, mappingCoord)

if (type == "NuageDePoints"){
  if (args[8] == "None"){
    repType = ggplot2::geom_point()
  } else {
    repType = ggplot2::geom_point(aes_string(color =  colVar))
  }
} else if (type == "DiagrammeEnBarre"){
  if (args[8] == "None"){
    repType = ggplot2::geom_col()
  } else {
    repType = ggplot2::geom_col(aes_string(fill =  colVar))
  }
} else if (type == "BoitesDeDispersion"){
  if (args[8] == "None"){
    repType = ggplot2::geom_boxplot()
  } else {
    repType = ggplot2::geom_boxplot(aes_string(color =  colVar))
  }
} else if (type == "Densite"){
  repType = ggplot2::geom_hex()
} else if (type == "Lignes"){
  if (args[8] == "None"){
    repType = ggplot2::geom_line()
  } else {
    repType = ggplot2::geom_line(aes_string(color =  colVar))
  }
} else if (type == "LigneEtPoints"){
  if (args[8] == "None"){
    plot_out = plot_out + ggplot2::geom_line()
    repType = ggplot2::geom_point()
  } else {
    plot_out = plot_out + ggplot2::geom_line(aes_string(color =  colVar))
    repType = ggplot2::geom_point(aes_string(color =  colVar))
  }
}


plot_out <- plot_out + repType

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

if (args[9] != "None") {
  facetVar = names(input)[as.numeric(args[9])]
  plot_out <- plot_out + facet_wrap(facetVar)
}

plot_out <- plot_out +
  ggtitle(args[5]) +
  xlab(xlabContent) +
  ylab(ylabContent) +
  ggplot2::theme_minimal() +
  ggplot2::theme(axis.text=element_text(size=12),
                 axis.title=element_text(size=16),
                 strip.text.x = element_text(size = 14))


suppressMessages(ggplot2::ggsave("output1.png", plot = plot_out, device = "png", width = 6, height = 4))
