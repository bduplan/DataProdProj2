#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Define server
shinyServer(function(input, output) {
    stocks <- reactive({
        data("EuStockMarkets")
        stocks <- as.data.frame(EuStockMarkets)
        timeframe <- input$slider1
        difftf <- function(price){
            c(t(rep(NA, times = timeframe)), 
              diff(price, lag = timeframe)/
                price[1:(length(price)-timeframe)]*100)
        }
        
        stocks <- stocks %>%
            mutate(delta_DAX = difftf(DAX)) %>%
            mutate(delta_SMI = difftf(SMI)) %>%
            mutate(delta_CAC = difftf(CAC)) %>%
            mutate(delta_FTSE = difftf(FTSE))
        stockPrices <- stocks[, 1:4] %>%
            gather(index, price) %>%
            mutate(time = rep(time(EuStockMarkets), 4))
        stockDeltas <- stocks[, 5:8] %>%
            gather(index, delta)
        stocks <- cbind(stockPrices, stockDeltas[, "delta"])
        names(stocks)[4] <- "delta"
        return(stocks)
    })
    
    
    output$plot1 <- renderPlotly({
        timeframe <- input$slider1
        hoverText <- stocks()$delta
        fig <- plot_ly(data = stocks(), x = ~time, y =~price, color = ~index, 
                type = "scatter", mode = "lines", 
                hovertemplate = paste(
                    "year: %{x:.0f}<br>",
                    "%{yaxis.title.text}: %{y:$,.0f}<br>",
                    "<b>", timeframe, "-Day Delta: <b>",
                    sprintf("%+0.2f%%", hoverText), "</b><br>",
                    "<extra></extra>"
                ))
        fig <- fig %>%
            layout(hovermode = "x unified")
        print(fig)
    })
    
    output$text1 <- renderText(input$slider1)
})
