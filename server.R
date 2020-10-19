function(input, output) {
    output$dygraph <- renderDygraph({
        dygraph(stock_ts[,input$selected2], main = "Stock Price",width = '100px',height = 'auto') %>%  
            dyAxis("x", drawGrid = T) %>% 
            dyRangeSelector(height = 20) %>% 
            dyOptions(colors = rainbow_hcl(4)) %>% 
            dyEvent(filter(MyDat, symbol==input$selected2 & Beat_Miss == 'Beat')[[2]], label = NULL,color = 'green',labelLoc = 'bottom') %>% 
            dyEvent(filter(MyDat, symbol==input$selected2 & Beat_Miss == 'Miss')[[2]], label = NULL,color = 'red',labelLoc = 'bottom')
    }
    )
    
    output$dygraph1 <- renderDygraph({
        dygraph(stock_ts1[,input$selected2], main = "Return of Interest",width = '100px',height = 'auto') %>%  
            dyAxis("x", drawGrid = T) %>% 
            dyRangeSelector(height = 20) %>% 
            dyOptions(colors = rainbow_hcl(4))
    }
    )
    
    output$earning_perc <- DT::renderDataTable({
        datatable(earning_perc[,c(-3:-8,-14,-15)])
        
    })
    
    output$earning <- DT::renderDataTable({
        datatable(earning)
    })
    
    output$correlation <- renderPlot({
        ggcorrplot(cor(stock_ts,use = "pairwise.complete.obs"))
        
    })
    
    output$cortable <- DT::renderDataTable({
        cor(stock_ts,use = "pairwise.complete.obs")
    })
    
    output$table <- DT::renderDataTable(
        {datatable(MyDat[,-9:-15],rownames = F)
        }
    )
 }
    
    