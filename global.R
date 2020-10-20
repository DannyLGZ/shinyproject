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


MyDat = read.csv('MyDat_stock.csv')
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
earning_perc = MyDat %>% filter(!is.na(Beat_Miss)) %>% mutate(diff = round((price2- price)/price,3))
earning_perc %>% group_by(symbol,Beat_Miss) %>% mutate(avg1 = mean(diff[diff>0]),avg2 = mean(diff[diff<0])) -> earning_perc
earning_perc2 = earning_perc %>% select(symbol,date,eps_est,eps,Beat_Miss,diff) %>% gather(key='key',value = 'value',-symbol,-date,-Beat_Miss)