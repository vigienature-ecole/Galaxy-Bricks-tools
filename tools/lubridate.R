#!/usr/bin/env Rscript

# tool to select specific columns

#get arguments from galaxy xlm command
args = commandArgs(trailingOnly=TRUE)
#args <- c("../../Downloads/Données_VNE_Oiseaux_des_jardins.csv.csv", "2", "ymd", "yday", "tada")

input = args[1]
column = as.numeric(args[2])
inputDateFormat = args[3]
outputDateFormat = args[4]
inputName = args[5]




## Import file
input1 <- data.frame(data.table::fread(input))

## Parse time
result <- lubridate::parse_date_time(input1[ , column], inputDateFormat)

if (outputDateFormat == "second") {
  result <- second(result)
} else if (outputDateFormat == "minute") {
  result <- lubridate::minute(result)
} else if (outputDateFormat == "hour") {
  result <- lubridate::hour(result)
} else if (outputDateFormat == "day") {
  result <- lubridate::day(result)
} else if (outputDateFormat == "yday") {
  result <- lubridate::yday(result)
} else if (outputDateFormat == "mday") {
  result <- lubridate::mday(result)
} else if (outputDateFormat == "wday") {
  result <- lubridate::wday(result)
} else if (outputDateFormat == "week") {
  result <- lubridate::week(result)
} else if (outputDateFormat == "month") {
  result <- lubridate::month(result)
} else if (outputDateFormat == "year") {
  result <- lubridate::year(result)
} else if (outputDateFormat == "timeZone") {
  result <- lubridate::tz(result)
} else if (outputDateFormat == "dst") {
  result <- lubridate::dst(result)
}

head(result)
input1 <- data.frame(input1, res = as.character(result))
colnames(input1)[ncol(input1)] <- inputName
head(input1[ncol(input1)])
#write file
data.table::fwrite(input1, "result", sep =",")
