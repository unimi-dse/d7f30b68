
# stock_details() function -----------------------------------------------------------

#' Function that displays and plot the stock data
#' @param stock_name a sting that represent the symbol of the Company listed in NASDAQ
#' @param start_date a sting that represent the date; By default 10 years from current date is considered
#' @param end_date a sting that represent the date; Current date is taken as default if no value is provided
#' @return Data and plot
#' @author Rijin Baby
#' @details
#' The function initially cleans the entered argumets and check their validity. Then collect the data file,
#' dispalys the data for the analysis
#' @export
# @seealso \code{plot_ly}\code{layout}
# @seealso \code{read.csv} \code{View} \{globalVariables}
#' @importFrom plotly plot_ly layout
#' @importFrom utils View read.csv globalVariables
#' @importFrom dplyr mutate %>%
#' @importFrom lubridate years

stock_details <- function(stock_name, start_date=Sys.Date()-years(10),end_date=Sys.Date())
{
  # basic data cleaning steps
  Date <- Close_Price <- NULL
  stock_name <- toupper(stock_name)
  stock_name <- trimws(gsub("[^A-Z]","",stock_name))

  # Calling the function to check the arguments
  argument_validation(stock_name,start_date,end_date)

  # Calling check_file() function for the file path
  dest <- check_file(stock_name)

  # reading the data
  Stock_Info <- read.csv(dest, stringsAsFactors=FALSE)

  n <- which(colnames(Stock_Info)=="Close.Last")
  colnames(Stock_Info)[n] <- "Close_Price"

  # Removing the $ sign from the data columns
  Stock_Info[,c("Close_Price","Open","High","Low")] <- as.data.frame(apply
                                                               (Stock_Info[,c("Close_Price","Open","High","Low")],2,
                                                                 FUN = function(y) as.numeric(gsub("\\$","",y))))

  # converting the charater date argument to date
  Stock_Info$Date <- as.Date(Stock_Info$Date,format="%m/%d/%Y")
  #filtering data based on date range
  Stock_Info <- Stock_Info[-which(Stock_Info$Date<start_date|Stock_Info$Date>end_date),]

  # Displaying the final data
  View(Stock_Info)

  # Assigning the line colour based on the trend
  if(Stock_Info$Close_Price[nrow(Stock_Info)]<=Stock_Info$Close_Price[1])trend_color <- "blue"
  else trend_color <- "red"

  #plotting the data
  plotly::plot_ly(Stock_Info, x = ~Date, y = ~Close_Price, type = 'scatter', mode = 'lines',color = I(trend_color)) %>%
  plotly::layout(title =paste0(nasdaq::nasdaq_listed$Security_Name[which(stock_name==nasdaq::nasdaq_listed$Symbol)]," (",stock_name,")"))

  }

# check_file() function --------------------------------------------------------------

#Check if the data already exist in the directory else download and return the file path
#' Function that search for data file
#' @param stock_name a sting that represent the symbol of the Company listed in NASDAQ
#' @return file path of the csv file
#' @author Rijin Baby
#' @details
#' This function initially checks if the file with stock details is present in the directory or not.
#' If the file is found in the directory the file path is returned else this function download the file
#' from the NASDAQ website and return the file path. In case of no data present in the file the function terminates the process
#' @export
# @seealso \code{download.file}
#' @importFrom utils download.file
#' @importFrom lubridate years

check_file <- function(stock_name)
{
  # Construct web URL
  src <- paste0("https://www.nasdaq.com/api/v1/historical/",stock_name,"/stocks/",Sys.Date()-years(10),"/",Sys.Date())

  # Construct path for storing local file
  dest <- file.path("~/",paste0(stock_name,"_",Sys.Date()-years(10),"_",Sys.Date(),".csv"))

  # Don't download if the file is already there!
  if(!file.exists(dest))
    download.file(src, dest, quiet = TRUE)

  # Checking if the file has data or not
  my_text<-readLines(dest)
  ifelse(my_text==""&length(my_text)==1,stop("NO DATA FOUND ON THE WEBSITE, KINDLY MODIFY THE INPUT DATE"),
         return(dest))
}

# argument_validation() function -----------------------------------------------------

#' Function that checks the format of arguments entered
#' @param stock_name a sting that represent the symbol of the Company listed in NASDAQ
#' @param start_date a sting that represent the date
#' @param end_date a sting that represent the date
#' @return TRUE if all the arguments are perfect else terminates the process
#' @author Rijin Baby
#' @details
#' This function checks validity of stock name and if the date value entered is in the YYYY-MM-DD format
#' @export

argument_validation <- function(stock_name, start_date,end_date)
{
  if(!(stock_name %in% nasdaq::nasdaq_listed$Symbol))    #Checks stock Name
  {
    stop("Check Stock Name; Refer nasdaq_listed dataset")
  }

  if(!IsDate(start_date)|!IsDate(end_date))   #Checks date fornat
  {
    stop("Check Date Format")
  }
}

# IsDate() function -----------------------------------------------------------------

#' Function that checks the date format
#' @param mydate a sting that represent the date
#' @param date.format explicitly specifying the date format
#' @return boolean value depending on the mydate value passed as argument
#' @details
#' This function checks if the date value entered is in the YYYY-MM-DD format
#' @export

IsDate <- function(mydate, date.format = "%Y-%m-%d")
{
  tryCatch(!is.na(as.Date(mydate, date.format)), error = function(err) {FALSE})
}

