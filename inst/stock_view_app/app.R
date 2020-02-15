
library(shiny)
library(dplyr)
require(DT)

# Define UI for application that displays stock information
ui <- fluidPage(

    # Application title
    titlePanel(h2("Historical Stock Price Analysis")),

    # Sidebar for input options
    sidebarLayout(
        sidebarPanel(
            width = 3,

            #Setting up input values
            dateInput("start_date1", label = h3("Start Date"), value = Sys.Date()-lubridate::years(10),
                      min = Sys.Date()-lubridate::years(10),max =Sys.Date() ),
            dateInput("end_date1", label = h3("End Date"),
                      min = Sys.Date()-lubridate::years(10),max =Sys.Date() ),
            h6("Note: Change both the date values if the data is not updated"),
            selectInput("stock",label = h3("Stock Symbol"),choices = nasdaq::nasdaq_listed$Symbol,selected = "AAPL"),

            #Action button to view the symbols
            actionButton("view_symbol","View Symbol"),
            DT::dataTableOutput("symbol_table")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotly::plotlyOutput("testplot1"),
            # h2("Data"),
           DT::dataTableOutput("mytable"),
        )
    )
)

# Defining server logic required to show information
server <- function(input, output) {

    #rendering the input values for plot
    output$testplot1 <- plotly::renderPlotly({
        start_date <- input$start_date1
        end_date <- input$end_date1
        stock_name <- input$stock
        Stock_Info <- nasdaq::stock_details(stock_name,start_date,end_date)

        #setting up graph
        ifelse(Stock_Info$Close_Price[nrow(Stock_Info)]<=Stock_Info$Close_Price[1],trend_color <- "blue",
               trend_color <- "red")
        (plotly::plot_ly(Stock_Info, x = ~Date, y = ~Close_Price, type = 'scatter', mode = 'lines',color = I(trend_color)) %>%
                plotly::layout(title =paste0(nasdaq::nasdaq_listed$Security_Name[which(stock_name==nasdaq::nasdaq_listed$Symbol)]," (",stock_name,")"))
        )
    })

    #rendering the input values for data table
    output$mytable = DT::renderDataTable({
        start_date <- input$start_date1
        end_date <- input$end_date1
        stock_name <- input$stock
        Stock_Info <- nasdaq::stock_details(stock_name,start_date,end_date)
        Stock_Info
    })

    # #setting up action button
    data_view <- eventReactive(input$view_symbol,{
        as.data.frame(nasdaq::nasdaq_listed[,c("Symbol","Security_Name")])
    })
    output$symbol_table <- DT::renderDataTable({
        data_view()
    })
}

# Run the application
shinyApp(ui = ui, server = server)
