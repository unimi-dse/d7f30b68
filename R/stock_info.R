
# stock_details() function -----------------------------------------------------------

#' Function that displays and plot the stock data
#' @param stock_name a sting that represent the symbol of the Company listed in NASDAQ
#' @param start_date a sting that represent the date
#' @param end_date a sting that represent the date; Current date is taken as default if no value is provided
#' @return Data and plot
#' @author Rijin Baby
#' @details
#' The function initially cleans the entered argumets and check their validity. Then collect the data file,
#' dispalys the data for the analysis
#' @export
#' @seealso \code{ggplot} \code{aes} \code{labs} \code{geom_line}
#' @seealso \code{read.csv} \code{View} \{globalVariables}
#' @importFrom ggplot2 ggplot aes labs geom_line
#' @importFrom utils View read.csv globalVariables

stock_details <- function(stock_name, start_date,end_date=Sys.Date())
{
  # basic data cleaning steps
  Date <- Close <- NULL
  stock_name <- toupper(stock_name)
  stock_name <- trimws(gsub("[^A-Z]","",stock_name))

  # Calling the function to check the arguments
  argument_validation(stock_name,start_date,end_date)

  # Calling check_file() function for the file path
  dest <- check_file(stock_name, start_date,end_date)

  # reading the data
  Stock_Info <- read.csv(dest, stringsAsFactors=FALSE)

  n <- which(colnames(Stock_Info)=="Close.Last")
  colnames(Stock_Info)[n] <- "Close"

  # Removing the $ sign from the data columns
  Stock_Info[,c("Close","Open","High","Low")] <- as.data.frame(apply
                                                               (Stock_Info[,c("Close","Open","High","Low")],2,
                                                                 FUN = function(y) as.numeric(gsub("\\$","",y))))

  # converting the charater date argument to date
  Stock_Info$Date <- as.Date(Stock_Info$Date,format="%m/%d/%Y")

  # Displaying the final data
  View(Stock_Info)

  # Assigning the line colour based on the trend
  if(Stock_Info$Close[nrow(Stock_Info)]<=Stock_Info$Close[1])trend_color <- "blue"
  else trend_color <- "red"

  #plotting the data
  ggplot(data = Stock_Info,aes(x=Date,y=Close)) +
                  geom_line(color=trend_color) +
                    labs(title = stock_name,
                       subtitle = paste0(min(Stock_Info$Date)," to ",max(Stock_Info$Date)))
}



# check_file() function --------------------------------------------------------------

#Check if the data already exist in the directory else download and return the file path
#' Function that search for data file
#' @param stock_name a sting that represent the symbol of the Company listed in NASDAQ
#' @param start_date a sting that represent the date
#' @param end_date a sting that represent the date
#' @return file path of the csv file
#' @author Rijin Baby
#' @details
#' This function initially checks if the file with stock details is present in the directory or not.
#' If the file is found in the directory the file path is returned else this function download the file
#' from the NASDAQ website and return the file path. In case of no data present in the file the function terminates the process
#' @export
#' @seealso \code{download.file}
#' @importFrom utils download.file

check_file <- function(stock_name, start_date,end_date)
{
  # Construct web URL
  src <- paste0("https://www.nasdaq.com/api/v1/historical/",stock_name,"/stocks/",start_date,"/",end_date)

  # Construct path for storing local file
  dest <- file.path("~/",paste0(stock_name,"_",start_date,"_",end_date,".csv"))

  # Don't download if the file is already there!
  if(!file.exists(dest))
    download.file(src, dest, quiet = TRUE)

  # Checking if the file has data or not
  my_text<-readLines(dest)
  ifelse(my_text==""&length(my_text)==1,stop("NO DATA AVAILABLE, KINDLY CHECK THE INPUT DATE"),return(dest))

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
  if(!(grepl("[A-Z]",stock_name)))    #Checks stock Name
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
#' @author Rijin Baby
#' @details
#' This function checks if the date value entered is in the YYYY-MM-DD format
#' @export

IsDate <- function(mydate, date.format = "%Y-%m-%d")
{
  tryCatch(!is.na(as.Date(mydate, date.format)), error = function(err) {FALSE})
}

