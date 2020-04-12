#!/usr/bin/env Rscript

# Plot output from column Summary

#get arguments from galaxy xlm command
args = commandArgs(trailingOnly=TRUE)

graphTitle = args[2]
xlab =       args[3]
ylab =       args[4]

## Import file
input <- data.frame(data.table::fread(args[1]))

#rotate data.frame
input <- data.frame(t(input))
input$X <- row.names(input)
colnames(input) <- c("Y", "X")

# add labels
if (xlab != ""){
  xlabContent = xlab
} else {
  xlabContent = "X"
}

if (ylab != ""){
  ylabContent = ylab
} else {
  ylabContent = "Y"
}

plot_out = ggplot2::ggplot(input, ggplot2::aes(x = X, y = Y)) +
  ggplot2::geom_col(ggplot2::aes(fill =  X), show.legend = FALSE) +
  ggplot2::ggtitle(graphTitle) +
  ggplot2::xlab(xlabContent) +
  ggplot2::ylab(ylabContent) +
  ggplot2::theme_minimal() +
  ggplot2::theme(axis.text = ggplot2::element_text(size=12),
                 axis.title = ggplot2::element_text(size=16),
                 strip.text.x = ggplot2::element_text(size = 14))+
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 35, hjust = 1))

suppressMessages(ggplot2::ggsave("output1.png", plot = plot_out, device = "png", width = 7, height = 6))
