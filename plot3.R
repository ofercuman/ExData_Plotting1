
## This assignment uses data from the UC Irvine Machine Learning Repository, 
## a popular repository for machine learning datasets. In particular, we will 
## be using the "Individual household electric power consumption Data Set" 
## which I have made available on the course web site:

## Dataset: Electric power consumption [20Mb]
## Description: 
##        Measurements of electric power consumption in one household with a 
##        one-minute sampling rate over a period of almost 4 years. 
##        Different electrical quantities and some sub-metering values are 
##        available.

## The following descriptions of the 9 variables in the dataset are taken from 
## the UCI web site:
##      1.Date: Date in format dd/mm/yyyy 
##      2.Time: time in format hh:mm:ss 
##      3.Global_active_power: household global minute-averaged active power 
##              (in kilowatt) 
##      4.Global_reactive_power: household global minute-averaged reactive 
##              power (in kilowatt) 
##      5.Voltage: minute-averaged voltage (in volt)                                                                           
##      6.Global_intensity: household global minute-averaged current 
##              intensity (in ampere) 
##      7.Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active 
##              energy). 
##                      It corresponds to the kitchen, containing mainly a 
##                      dishwasher, an oven and a microwave
##                      (hot plates are not electric but gas powered). 
##      8.Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active 
##                      energy). 
##                      It corresponds to the laundry room, containing a 
##                      washing-machine, a tumble-drier, a
##                      refrigerator and a light. 
##      9.Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active 
##              energy). 
##                      It corresponds to an electric water-heater and an 
##                      air-conditioner.


rm(list = ls(all = T))

if (!file.exists("./Data/HPC/household_power_consumption.txt") == T) {
        
        fileurl <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        
        dir.create("./Data/HPC")
        
        download.file(fileurl, destfile = "./Data/HPC/HPC.zip")
        
        unzip("./Data/HPC/HPC.zip", exdir = "./Data/HPC")
        
}

##      The dataset has 2,075,259 rows and 9 columns. 
##      First calculate a rough estimate of how much memory the 
##              dataset will require in memory before reading into R. 
##      Make sure your computer has enough memory 
##              (most modern computers should be fine).
##      Note that in this dataset missing values are coded as ?.
##      Rough estimate ~= 2,075,259 * 9 * 8 bytes/numeric = 149,418,648 bytes; /2^20 bytes/MB = 142.5MB * 2 = 285MB


initialread <- read.table(
        "./Data/HPC/household_power_consumption.txt", 
        header = T, 
        sep = ";", 
        nrows = 100
)

classes <- sapply(initialread, class)

df0 <- read.table(
        "./Data/HPC/household_power_consumption.txt", 
        header = T, 
        sep = ";", 
        na.strings = "?", 
        colClasses = classes[1:9], 
        nrows = 2075259
)


##      You may find it useful to convert the Date and Time variables 
##      to Date/Time classes in R 
##      using the strptime() and as.Date() functions.

df0$Date.Time0 <- paste(df0$Date, df0$Time)
df0$Date.Time <- strptime(df0$Date.Time0, "%d/%m/%Y %T")
df0$Date <- as.Date(df0$Date, "%d/%m/%Y")

## remove old date columns

df <- df0[, c(1,11,3:9)]

## remove old objects

rm("classes", "initialread", "df0")

dfdat <- df[which(df$Date == "2007-02-01" | df$Date == "2007-02-02"), c(1:9)]

## remove old data frame

rm("df")

## dfdat$Day <- format(dfdat$Date, "%a")

png(filename = "./Graphics/plot3.png", width = 480, height = 480)

plot(
     x = dfdat$Date.Time, 
     y = dfdat$Sub_metering_1, 
     type = "l", 
     xlab = "", 
     ylab = "Energy sub metering"
    )

lines(x = dfdat$Date.Time, y = dfdat$Sub_metering_2, type = "l", col = "red")
lines(x = dfdat$Date.Time, y = dfdat$Sub_metering_3, type = "l", col = "blue")
legend(
        "topright", 
        legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
        lwd = 1, 
        col = c("black", "red", "blue"), 
        pch = c(NA,NA,NA)
       )

dev.off()

