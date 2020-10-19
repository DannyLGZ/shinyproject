function(input, output) {
#     output$hist = renderGvis(
#         gvisHistogram(state_stat[,input$selected,drop=F])
#     )
#     
#     output$map <- renderGvis({
#         gvisGeoChart(state_stat, "state.name", input$selected,
#                      options=list(region="US", displayMode="regions",
#                                   resolution="provinces",
#                                   width="auto", height="auto"))
#         # using width="auto" and height="auto" to
#         # automatically adjust the map size
#     })
#     
#     output$table <- renderDataTable(
#         {datatable(state_stat,rownames = F) %>% 
#                 formatStyle(input$selected,
#                             background = 'skyblue',fontWeight = 'bold')}
#         
#     )
#     
#     output$max=renderInfoBox({
#         max_value <- max(state_stat[,input$selected])
#         max_state <-
#             state_stat$state.name[state_stat[,input$selected]==max_value]
#         infoBox(max_state,max_value,icon = icon('hand-o-up'))
#     })
#     
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
    
    
    # output$stockgraph <- renderPlot({
    #     MyDat %>% filter(symbol == input$selected1) %>%  arrange(date)%>%    
    #         mutate(Close=price/first(price))%>% 
    #         ggplot(aes(x = date, y = price, color = symbol)) +
    #         geom_line() +scale_x_date(date_breaks = "3 months") +
    #         theme(axis.text.x = element_text(angle = -45, hjust = 0))
        
    # })
    
    
    output$table <- DT::renderDataTable(
        {datatable(MyDat[,-9:-15],rownames = F)
        }
    )
    
    
        
    
    
    
    
    
    
 }
    
    