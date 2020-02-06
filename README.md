<<<<<<< HEAD
# test2
=======
---
# 'nasdaq: Stock Analysis'
---

## Description

The nasdaq pakage accept the stock informations like stock name and date range values from the user and provide the user all the stock values between the date range along with the trend graph.

## Installation
```
# first install the R package "devtools" if not installed
devtools::install_github('unimi-dse/d7f30b68')
```
## Dataset
The package contains a datset for all the nasdaq listed stock name and its symbols along with other useful information. Reference <http://www.nasdaqtrader.com/trader.aspx?id=symboldirdefs>
```
#nasdaq_listed dataset documentation
?nasdaq::nasdaq_listed
```
## Usage
```
# load the package
require(nasdaq)

#calling the main function
stock_details(stock_name, start_date,end_date)
```
## Arguments
Argument Name  | Description
---------------|--------------
*stock_name*   |Symbol of the stock
*start_date*   |Initial date in YYYY-MM-DD format
*end_date*     |Final date in YYYY-MM-DD format; By default this takes todays date

## Example
```
#To see the stock information of Apple Inc.
stock_details("AAPL","2017-02-12","2020-01-30")
```
>>>>>>> 56a29623eaffd13d9391117f6c079d29190c118d
