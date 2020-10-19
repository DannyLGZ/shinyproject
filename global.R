library(shiny)
library(shinydashboard)
library(googleVis)
library(DT)
library(tidyverse)
library(lubridate)
library(dygraphs)
library(plotly)
library(colorspace)
library(ggcorrplot)
library(xts)


MyDat = read.csv('stock_df_2.csv')
MyDat$date = as.Date(MyDat$date)
MyDat = MyDat %>% group_by(symbol) %>% arrange(date) %>% filter(year(date)>='2010')%>% mutate(Close = price/first(price),price2 = c(tail(price,-1),1)) 
MyDat2 = pivot_wider(MyDat, id_cols = date, names_from = symbol, values_from = close)
MyDat3 = pivot_wider(MyDat, id_cols = date, names_from = symbol, values_from = Close)
stock_ts = xts(MyDat2[,-1],order.by = (MyDat2$date))
stock_ts1 = xts(MyDat3[,-1],order.by = (MyDat3$date))
beat_up = MyDat %>% group_by(symbol) %>% filter(Beat_Miss=='Beat' & price2 - price> 0) %>% summarise(beat_up = n())
beat_down = MyDat %>% group_by(symbol) %>% filter(Beat_Miss=='Beat' & price2 - price< 0) %>% summarise(beat_down = n())
miss_up = MyDat %>% group_by(symbol) %>% filter(Beat_Miss=='Miss' & price2 - price> 0) %>% summarise(miss_up = n())
miss_down = MyDat %>% group_by(symbol) %>% filter(Beat_Miss=='Miss' & price2 - price< 0) %>% summarise(miss_down = n())
earning = left_join(beat_up,beat_down) %>% left_join(.,miss_up) %>% left_join(.,miss_down)
earning[is.na(earning)]=0
earning %>% mutate(beat_perc = round(beat_up/(beat_up + beat_down)*100,3),miss_perc = round(miss_down/(miss_up + miss_down)*100,3))->earning
earning_beat_perc = MyDat %>% group_by(symbol) %>% filter(Beat_Miss=='Beat') %>% mutate(diff= round((price2- price)/price*100,3))
earning_miss_perc = MyDat %>% group_by(symbol) %>% filter(Beat_Miss=='Miss') %>% mutate(diff= round((price2- price)/price*100,3))
earning_perc = full_join(earning_beat_perc,earning_miss_perc)


# 
# state_stat=data.frame(state.name=rownames(state.x77),
#                       state.x77)
# rownames(state_stat)=NULL
# choice <- colnames(state_stat)[-1]