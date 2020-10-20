function(input, output) {
    output$dygraph <- renderDygraph({
        dygraph(stock_ts[,input$selected1], main = "Stock Price",width = '100px',height = 'auto') %>%  
            dyAxis("x", drawGrid = T) %>% 
            dyRangeSelector(height = 20) %>% 
            dyOptions(colors = rainbow_hcl(4)) %>% 
            dyEvent(filter(MyDat, symbol==input$selected1 & Beat_Miss == input$selected3)[[2]], label = NULL, color = rainbow_hcl(4) ,labelLoc = 'bottom')
            #dyEvent(filter(MyDat, symbol==input$selected2 & Beat_Miss == 'Miss')[[2]], label = NULL,color = 'red',labelLoc = 'bottom')
    }
    )
    
    output$dygraph2 <- renderDygraph({
        dygraph(stock_ts[,input$selected2], main = "Stock Price",width = '100px',height = 'auto') %>%  
            dyAxis("x", drawGrid = T) %>% 
            dyRangeSelector(height = 20) %>% 
            dyOptions(colors = rainbow_hcl(4))
        
    })
    
    
    output$dygraph1 <- renderDygraph({
        dygraph(stock_ts1[,input$selected2], main = "Return of Interest",width = '100px',height = 'auto') %>%  
            dyAxis("x", drawGrid = T) %>% 
            dyRangeSelector(height = 20) %>% 
            dyOptions(colors = rainbow_hcl(4))
    }
    )
    
    output$plot1 <- renderPlotly({
        ggplotly({
            earning_perc2 %>% filter(symbol==input$selected1 & Beat_Miss==input$selected3) %>% ggplot(aes(x=symbol,y=value))+geom_boxplot(aes(fill=key))
        }) %>% layout(boxmode='group')
        
    })
    
    output$plot2 <- renderPlotly({
        earning_perc %>% filter(symbol==input$selected1 & Beat_Miss==input$selected3) %>% ggplot(aes(x = date))+geom_bar(aes(y=diff),stat = "identity")+
            geom_point(aes(y= eps,color = 'eps')) + geom_point(aes(y= eps_est ,color = 'eps_est')) + geom_hline(aes(yintercept = avg1)) + 
            geom_hline(aes(yintercept = avg2))
    })
    
    
    
    output$earning_perc <- DT::renderDataTable({
        datatable(earning_perc[,c(-3:-8,-14,-15,-17,-18)])
        
    })
    
    output$earning <- DT::renderDataTable({
        datatable(earning)
    })
    
    output$correlation <- renderPlot({
        ggcorrplot(cor(stock_ts,use = "pairwise.complete.obs"))
        
    })
    
    output$correlation2 <- renderPlot({
        ggcorrplot(cor(stock_ts1,use = "pairwise.complete.obs"))
        
    })
    
    output$cortable <- DT::renderDataTable({
        cor(stock_ts,use = "pairwise.complete.obs")
    })
    
    output$cortable2 <- DT::renderDataTable({
        cor(stock_ts1,use = "pairwise.complete.obs")
    })
    
    output$table <- DT::renderDataTable(
        {datatable(MyDat[,-9:-15],rownames = F)
        }
    )
 }
    
    