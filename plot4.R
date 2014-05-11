## A script to:
## Read the data and create a histogram with red bars
##
## 1.Date: Date in format dd/mm/yyyy 
## 2.Time: time in format hh:mm:ss 
## 3.Global_active_power: household global minute-averaged active power (in kilowatt) 
## 4.Global_reactive_power: household global minute-averaged reactive power (in kilowatt) 
## 5.Voltage: minute-averaged voltage (in volt) 
## 6.Global_intensity: household global minute-averaged current intensity (in ampere) 
## 7.Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered). 
## 8.Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light. 
## 9.Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.

##
## Download and read in the file
##

source("downloadAndUnzip.R")

# download and Unzip.R contains the below code


#library(downloader) 
#URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
#zipFile <- "exdata_data_household_power_consumption.zip"
#download(URL, zipFile, mode="wb")
#powerConsumptionFile <- unzip(zipFile)

#
# Read the first row to get a vector for the column names
# And to determine the first date/time in the file
#
powerConsumptionHeader <- read.table(powerConsumptionFile, 
                                     nrows=1, header=TRUE, sep = ";")

#
# Find the first date in the file, and subtract the date we're trying to
# start with, to determine the number of rows to skip
#

startDate <- strptime(paste(powerConsumptionHeader$Date, powerConsumptionHeader$Time), format="%d/%m/%Y %H:%M:%S")
endDate <- strptime('01/02/2007 00:00:00',format="%d/%m/%Y %H:%M:%S")
skipRows <- as.numeric(difftime(endDate, startDate, units="mins"))

#
# We know we are processing data for 2 days, 60 * 24 * 2 = 2880 
#

nRows <- 60 * 24 * 2

powerConsumption <- read.table(powerConsumptionFile, 
                              skip = skipRows, nrows = nRows, header=TRUE, sep=";",
                              na.strings = "?",
                              col.names=colnames(powerConsumptionHeader))

dates <- c("2/1/2007","2/2/2007","2/3/2007")
days <- format(as.Date(dates, "%m/%d/%Y"), "%a")
minutes <- c(0, 1440, 2880)
rangeOfPC <- range(0, 
                   powerConsumption$Sub_metering_1, 
                   powerConsumption$Sub_metering_2, 
                   powerConsumption$Sub_metering_3)
rangeOfGAP <- range(powerConsumption$Global_active_power)
rangeOfV <- range(powerConsumption$Voltage)

#
# Create the plot
#

png(filename = "plot4.png",
    width = 480,
    height = 480,
    restoreConsole = TRUE
)

par(mfrow=c(2,2))

# Create upper left plot
# uses the same code from Plot 1

plot(powerConsumption$Global_active_power, 
     type="l",
     axes=FALSE,
     ann=FALSE)
axis(1, at=minutes, lab=days)
axis(2, las=1, at=2*0:rangeOfGAP[2])
box()
title(ylab="Global Active Power (kilowatts)")

# Create upper right plot

plot(powerConsumption$Voltage,
     type="l",
     axes=FALSE,
     ann=FALSE)
axis(1, at=minutes, lab=days)
axis(2, las=1, at=c(234,238,242,246))
box()
title(ylab="Voltage", xlab="datetime")

# create lower left plot
# uses the same code from plot 3

plot(powerConsumption$Sub_metering_1,
     col="black",
     type="h",
     axes=FALSE,
     ann=FALSE)
lines(powerConsumption$Sub_metering_2, type="l", col="red")
lines(powerConsumption$Sub_metering_3, type="l", col="blue")
axis(1, at=minutes, lab=days)
axis(2, las=1, at=10*0:rangeOfPC[2])
box()
title(ylab="Energy sub metering")
legend(1, c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"),
       x="topright",
       col=c("black","red","blue"),
       lty=c(1,1,1),
       cex=.6, bty="n")

# Create lower right plot


plot(powerConsumption$Global_reactive_power, 
     type="h",
     axes=FALSE,
     ann=FALSE)
axis(1, at=minutes, lab=days)
axis(2, las=1, at=c(0.0,0.1,0.2,0.3,0.4,0.5))
box()
title(ylab="Global_reactive_power", xlab="datetime")

dev.off()
