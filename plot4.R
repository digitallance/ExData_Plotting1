##
##  "Exploratory Data Analysis" Course Project 1
##
##  part 4: Multiple Plots
##

##
##  Create a smaller sample data file with the desired data range 
##  from the original 127MB data file to prevent loading the full 
##  dataset into memory
##
##  - this step is time consuming and is required only once
##  - once generated, the sample data file can be loaded quickly 
##    for exploratory plots and testing
##  - the code is included in order to allow full reproducibility
##    

# set filtered data file location (REQUIRED)
fname.sample <- "sample.txt"

# filter large data file (needs to be performed only is sample data file does not exist)
generate.sample <- TRUE # FALSE
if (generate.sample) {
  # set location of original data file
  fname.original <- "../household_power_consumption.txt"
  # open file connections/handles to original and sample files
  fhin <- file(fname.original, open="r")
  fhout <- file(fname.sample, open="w")
  # get header from oriianl data file
  line <- readLines(fhin, n=1)
  # write header to sample file
  writeLines(line, fhout)
  # step through data file one line at a time looking for matching dates
  # in column 1 for generating sample data
  line <- readLines(fhin, n=1)
  while (length(line)) {
    # split columns to access date in column 1
    cols <- strsplit(line, ';')
    if (length(cols[[1]]) > 1) {
      if (cols[[1]][1] == '1/2/2007' | cols[[1]][1] == '2/2/2007') {
        # save row in sample file
        writeLines(line, fhout)
      }
    }
    # get the next line
    line<- readLines(fhin, n=1)
  }
  # close file connections
  close(fhin)
  close(fhout)
} # finshed generating sample data file

## load sample data into a table
data <- read.table(fname.sample, sep=";", header=TRUE)

## generate plots

## reset device to default state
if (dev.cur() > 1) {dev.off()}

# create a 2x2 lpot grid, set margins and default font size
par(mfrow=c(2,2), mar=c(4,4,4,2), oma=c(1,2,2,1), cex=0.6)

## subplot 1: "Global active power" vs. Day

## read in date/time info in format 'm/d/y h:m:s'
dates <- data$Date
times <- data$Time
# merge
datetime <- paste(dates, times)
# prepare x-axis data points as "POSIXlt" objects
x <- strptime(datetime, "%d/%m/%Y %H:%M:%S")
# plot "Global_active_power"
plot(x, data$Global_active_power, xaxt='n', type='l', xlab="", 
     ylab="Global Active Power (kilowatts)")
# generate x-axis labels as a 3 item sequence spanning datatime range
xlabels <- seq(x[1], x[length(x)], length.out=3)
# add axis to the plot in weekday short format "%a"
axis(side=1, at=xlabels, labels=strftime(xlabels, format="%a"))

## subplot 2: Votage vs. Day

# plot Voltage
plot(x, data$Voltage, xaxt='n', type='l', 
     ylab="Voltage", xlab="datetime")
# regenerate x-axis labels to prevent errors due to any future changes to prior plot(s)
xlabels <- seq(x[1], x[length(x)], length.out=3)
# add axis to the plot in weekday short format "%a"
axis(side=1, at=xlabels, labels=strftime(xlabels, format="%a"))

## subplot 3: "Energy sub metering" vs. Day

# initialize plot with sample 1
plot(x, data$Sub_metering_1, xaxt='n', type='l', xlab="", 
     ylab="Energy sub metering")
# add sample 2 plot
lines(x, data$Sub_metering_2, col="red")
# add sample 3 plot
lines(x, data$Sub_metering_3, col="blue")
# regenerate x-axis labels to prevent errors due to any future changes to prior plot(s)
xlabels <- seq(x[1], x[length(x)], length.out=3)
# add axis to the plot in weekday short format "%a"
axis(side=1, at=xlabels, labels=strftime(xlabels, format="%a"))
# add legend for data subsets
legend('topright', c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), 
       bty='n', lty=1, cex=1, col=c('black', 'red', 'blue'), inset=c(.1,0))

## subplot 4: "Global reactive power" vs. Day

# plot Global Reactive Power
plot(x, data$Global_reactive_power, xaxt='n', type='l', 
     ylab="Global_reactive_power", xlab="datetime")
# regenerate x-axis labels to prevent errors due to any future changes to prior plot(s)
xlabels <- seq(x[1], x[length(x)], length.out=3)
# add axis to the plot in weekday short format "%a"
axis(side=1, at=xlabels, labels=strftime(xlabels, format="%a"))

# copy plot from the screen to a PNG file
dev.copy(png, file="plot4.png")
# close the PNG device
dev.off()
