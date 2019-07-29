# tool for simple linear regression
#
#  Input :
#     1. dataset
#     2. dependant variable
#     3. explanatory variable
#  Output :
#     1. significance
#     2. coeficients
#     3. graph

#get arguments from galaxy xlm command
args = commandArgs(trailingOnly=TRUE)

# import package
library(data.table) # for data import

# import input file (tabular or csv)
input = fread(args[1])

# run linear model
res <- lm(input[args[2]] ~ input[args[3]])
# get output from linear model
results <- summary(res)

# add sentence to translate strength of correlation
# Not implemented yet
rsquared <- results$r.squared

if (rsquared < .2^2){link = "no or very weak link"} else if(rsquared < .4^2){link = "weak link"
} else if(rsquared <  .6^2){link = "medium link"
} else if(rsquared <  .8^2){link = "strong link"
} else {link = "very strong link"
}


# Output 1 and 2
capture.output(results, file="mod-summary.txt")

# Output 3 Graph
# plot data and add trend line
png('output-plot.png')
plot(input[args[2]], inputTest[args[3]])
abline(res)
invisible(dev.off())
