library(shinydashboard)

shinyUI(dashboardPage(skin = 'green',
    dashboardHeader(title='SP 500 vs. FAANG'),
    dashboardSidebar(
        sidebarUserPanel('NYC DSA'),
        sidebarMenu(
            menuItem('Introduction', tabName = 'intro', icon = icon('book-open')),
            menuItem('Analysis',tabName = 'analysis',icon=icon('chart-line')), 
            menuItem('Data',tabName = 'data',icon = icon('columns')), 
            menuItem('About',tabName = 'about',icon = icon('address-book'))
        )
    ),
    dashboardBody(
        tabItems(
            tabItem(tabName = 'intro',
                    HTML('
            <p><center><b><font size="8">Visualizing SP500 and FAANG Stock Price</font></b></center></p>
            <p><center><font size="6">Analyze relationship between SP500 and FAANG and how earning reports drive stock price</font></center></p>
            <p><pre><center><font size="4">
            <b>Objective</b>: The purpose of this project is to visualize the return of interest of SP500 and FAANG stocks from 2010 to 2020. 
            Facebook(FB),Apple(AAPL), Amazon(AMZN), Netflix(NFLX), and Alphabet(GOOG), are used to represent the US economy and have risen so 
            much among all other stocks. This project helps us to understand the correlation of SP500 and FAANG, the interrelation among FAANG 
            stocks, and how quaterly earning reports affect the stock prices.  
            </font></center></pre></p>')

            ),
            
            tabItem(tabName = 'analysis',            
                    tabsetPanel(type = 'tabs',
                                tabPanel("ROI",
                                         fluidRow(
                                             column(width = 6, checkboxGroupInput("selected2","Stocks",choices = unique(MyDat$symbol),selected = 'SP500')
                                             )
                                         ),
                                         fluidRow(box(dygraphOutput('dygraph2'),width = 12)),
                                         
                                         fluidRow(box(dygraphOutput('dygraph1'),width = 12))
                                         ),
                                
                                tabPanel("Earning Report",
                                         fluidRow( 
                                             column(width = 6, selectizeInput("selected1","Stocks",choices = unique(MyDat$symbol),selected = 'AAPL')
                                                          ),
                                             column(width = 6, selectizeInput("selected3","Earning",choices = unique(MyDat$Beat_Miss))
                                                )
                                         ),
                                         fluidRow(box(dygraphOutput('dygraph'),width = 12)),
                                         fluidRow(
                                             box(DT::dataTableOutput('earning_perc'),width = 6),
                                             column(6,plotlyOutput('plot1')))
                                             #box(DT::dataTableOutput('earning'),width = 6))
                                ),
                                         
                                tabPanel("Correlation",
                                         fluidPage(
                                             fluidRow(box(plotOutput('correlation'),width = 5)),
                                             fluidRow(box(DT::dataTableOutput('cortable'),width = 5)))
                                         )
                                )
                                ),
            tabItem(tabName = 'data',
                    fluidRow(
                        box(DT::dataTableOutput('table'),width = 12)
                    )
            ),
            
            tabItem(tabName = 'about',
                    fluidPage(
                        column(6,HTML('
                              <p><font size = "4"> Thank you for your time looking at my Shiny project. </p>
                              <p>This project will be continued for further diversification porfolio analysis. </p> 
                              <p>About myself: I graduated at the City College, CUNY with Bachelor in BioMedical Engineering. After graduation,
                              I did research on metastatic cancer at MSKCC. Then I start up my own enterprise on Ecommerce more than 5 years. I also 
                              opened a coffee shop because I love coffee. 
                              </p>
                              <p>I am so interested in data science because number can tell me story which I never think about.</p>
                              <p><a href="https://www.linkedin.com/in/lingge-danny-zeng-a6aa4350/>LinkedIn</a></p>
                              <p><a href="https://github.com/DannyLGZ/shinyproject">Shiny Project Code</a></p>
                              <p>E-mail: linggezeng@gmail.com</font></p>
                              <p><br></p>')),
                        # column(6,
                        #        HTML('<img src="danny.jpg", height="400px"    
                        #         style="float:left"/>','<p style="color:black"></p>'))
                        
                    )
            )
        )
    ),
)
)