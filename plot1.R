##
##  "Exploratory Data Analysis" Course Project 1
##
##  part 1: Global Active Power Histogram
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

# reset device to default state
if (dev.cur() > 1) {dev.off()}

# set margins and font size
par(mar=c(4,4,4,2), oma=c(1,2,2,1), cex=0.75)

# generate histogram
hist(data$Global_active_power, col="red", main="Global Active Power",
     xlab="Global Active Power (kilowatts)")
# copy plot from the screen to a PNG file
dev.copy(png, file="plot1.png")
# close the PNG device
dev.off()
