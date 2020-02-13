
---
# nasdaq: Historical Stock Price Analysis   
<div><img src="https://www.nasdaq.com/themes/nsdq/dist/assets/images/logo.svg" width="200px" align="right"></div>


## Description

The nasdaq pakage accept the stock details like stock name and date range values from the user and provide 
historical data up to 10 years of daily historical stock prices and volumes for each stock. Historical price trends can indicate the future direction of a stock.
<https://www.nasdaq.com/>

## Installation
```
# first install the R package "devtools" if not installed
devtools::install_github('unimi-dse/d7f30b68')
```
## Usage
```
# load the package
require(nasdaq)

#calling the main function
stock_details(stock_name, start_date,end_date)
```
# Arguments of stock_details()

Argument Name  | Description
---------------|--------------
*stock_name*   |Symbol of the stock
*start_date*   |Initial date in YYYY-MM-DD format; Default Value = 10 years from current date
*end_date*     |Final date in YYYY-MM-DD format; Default Value = Current Date

## Dataset
The package contains a datset for all the nasdaq listed stock name and its symbols along with other useful information. Reference <http://www.nasdaqtrader.com/trader.aspx?id=symboldirdefs>
```
#nasdaq_listed dataset documentation
?nasdaq::nasdaq_listed
```

## Example
```
#To see the stock information of Apple Inc.
stock_details("AAPL","2017-02-12","2020-01-30")

#To see the stock information of Facebook Inc.
stock_details("fb")
```
# Most Popular Stocks
SYMBOL       | COMPANY NAME
-------------|--------------
*AAPL*       |Apple, Inc.
*SBUX*       |Starbucks, Inc.
*MSFT*       |Microsoft, Inc.
*FB*         |Facebook, Inc.
*AMZN*       |Amazon.com, Inc.
*TSLA*       |Tesla, Inc.
*QCOM*       |QUALCOMM, Inc.
*CSCO*       |Cisco Systems, Inc.
