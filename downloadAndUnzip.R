## A script to:
##
## Download and read in the file
##

library(downloader) 
URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipFile <- "exdata_data_household_power_consumption.zip"
download(URL, zipFile, mode="wb")
powerConsumptionFile <- unzip(zipFile)

