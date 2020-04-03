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
#args <- c("tools/test-data/irisPlus.tabular",'5', '2', 'DiagrammeEnBarre', 'petitTest', 'espece', 'sepal', '6', 'None','4', 'FALSE')

# get parameters
inputFile  = args[1]
ColX       = as.numeric(args[2])
ColY       = as.numeric(args[3])
typeGraph  = args[4]
graphTitle = args[5]
xlab       = args[6]
ylab       = args[7]
colorGroup = args[8]
facetGroup = args[9]
Error      = args[10]
viewNC     = args[11]


# import package
library(data.table) # for data import
library(ggplot2)

# import input file (tabular or csv)
input = data.frame(fread(inputFile))

#remove numbers from factors for interest columns
removeBegining <- function (input, Column){
  if (Column != "None"){
    Column <- as.numeric(Column)
    if(is.factor(sapply(input[Column], class)) | is.character(sapply(input[Column], class))){
      if(any(grepl(pattern = "^[0-9][0-9]_", input[1:100, Column])))
        input[ , Column] <- substr(input[ , Column], 4, nchar(as.character(input[ , Column])))
    }
  }
  input
}

input <- removeBegining(input, ColX)
input <- removeBegining(input, ColY)
input <- removeBegining(input, colorGroup)
input <- removeBegining(input, facetGroup)

# Remove data "non renseignée"
if (viewNC == "FALSE"){
  input <- input[!grepl("Non renseign", input[ , ColX]) & !grepl("Non renseign", input[ , ColY]), ]
}

# rotate label for factors for better visualisation
optBarPlot = NULL
if(is.factor(sapply(input[ColX], class)) | is.character(sapply(input[ColX], class))){
  optBarPlot <- theme(axis.text.x=element_text(angle = 35, hjust = 1))
}

# add colors
if (colorGroup != "None") colVar = names(input)[as.numeric(colorGroup)] else colVar = NULL

#define x and y axes
mappingCoord = ggplot2::aes_string(x = names(input)[ColX],
                                   y = names(input)[ColY])
# add error bars
if (!Error == "None"){
  input[, "ErreurPlus304094093403940392030231312"] <- input[ , ColY] + input[ , as.numeric(Error)]
  input[, "ErreurMoins304094093403940392030231312"] <- input[ , ColY] - input[ , as.numeric(Error)]
  errorPlot = geom_errorbar(data = input, aes(ymin = ErreurMoins304094093403940392030231312, ymax = ErreurPlus304094093403940392030231312), width = .3)
} else {
  errorPlot = NULL
}

# generate empty graph
plot_out <- ggplot2::ggplot(input, mappingCoord)


#add geom
if (typeGraph == "NuageDePoints"){
  if (colorGroup == "None"){
    repType = ggplot2::geom_point()
  } else {
    repType = ggplot2::geom_point(aes_string(color =  colVar))
  }
} else if (typeGraph == "DiagrammeEnBarre"){
  if (colorGroup == "None"){
    repType = ggplot2::geom_col()
  } else {
    repType = ggplot2::geom_col(aes_string(fill =  colVar))
  }
} else if (typeGraph == "BoitesDeDispersion"){
  if (colorGroup == "None"){
    repType = ggplot2::geom_boxplot()
  } else {
    repType = ggplot2::geom_boxplot(aes_string(color =  colVar))
  }
} else if (typeGraph == "Densite"){
  repType = ggplot2::geom_hex()
} else if (typeGraph == "Lignes"){
  if (colorGroup == "None"){
    repType = ggplot2::geom_line()
  } else {
    repType = ggplot2::geom_line(aes_string(color =  colVar))
  }
} else if (typeGraph == "LigneEtPoints"){
  if (colorGroup == "None"){
    plot_out = plot_out + ggplot2::geom_line()
    repType = ggplot2::geom_point()
  } else {
    plot_out = plot_out + ggplot2::geom_line(aes_string(color =  colVar))
    repType = ggplot2::geom_point(aes_string(color =  colVar))
  }
}


plot_out <- plot_out + repType

# add labels
if (xlab != ""){
  xlabContent = xlab
} else {
  xlabContent = colnames(input)[ColX]
}

if (ylab != ""){
  ylabContent = ylab
} else {
  ylabContent = colnames(input)[ColY]
}

# add facetting
if (facetGroup != "None") {
  facetVar = names(input)[as.numeric(facetGroup)]
  plot_out <- plot_out + facet_wrap(facetVar)
}

plot_out <- plot_out +
  ggtitle(graphTitle) +
  xlab(xlabContent) +
  ylab(ylabContent) +
  ggplot2::theme_minimal() +
  ggplot2::theme(axis.text=element_text(size=12),
                 axis.title=element_text(size=16),
                 strip.text.x = element_text(size = 14))+
  optBarPlot +
  errorPlot +
  theme(legend.position="bottom")


suppressMessages(ggplot2::ggsave("output1.png", plot = plot_out, device = "png", width = 7, height = 6))
