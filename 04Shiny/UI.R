#ui.R

require(shiny)
require(shinydashboard)
require(leaflet)

dashboardPage(
  dashboardHeader(title="Final Project"
  ),
  dashboardSidebar(
    sidebarMenu(
      actionButton(inputId = "clicks1",  label = "Update Data",width="100%"),
      menuItem("Non-Aggregate1", tabName = "Non-Aggregate1"),
      menuItem("Aggregate1", tabName = "Aggregate1"),
      menuItem("Scatter1", tabName = "scatter1"),
      menuItem("Scatter2", tabName = "scatter2"),
      menuItem("Scatter3", tabName = "scatter3"),
      menuItem("Scatter4", tabName = "scatter4"),
      menuItem("Scatter5", tabName = "scatter5")
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "scatter1",
        sliderInput("margins","Margin of Error",min=0,max=1, value = 0.95, step = 0.001),
        plotOutput(outputId = "scatter1",width='100%',height="800px")
      ),
      tabItem(tabName = "scatter2",
        sliderInput("year","Year",min=1992,max=1998, value = 1998, step = 1),
        sliderInput("margins2","Margin of Error",min=0,max=1, value = 0.95, step = 0.001),
        plotOutput(outputId = "scatter2",width='100%',height="400px")
      ),
      tabItem(tabName = "scatter3",
        sliderInput("year2","Year",min=1992,max=1998, value = 1998, step = 1),
        sliderInput("margins2","Margin of Error",min=0,max=1, value = 0.95, step = 0.001),
        plotOutput(outputId = "scatter3",width='100%',height="400px")
      ),
      tabItem(tabName = "scatter4",
        sliderInput("year3","Year",min=1992,max=1998, value = 1998, step = 1),
        sliderInput("margins3","Margin of Error",min=0,max=1, value = 0.95, step = 0.001),
        plotOutput(outputId = "scatter4",width='100%',height="400px")
      ),
      tabItem(tabName = "scatter5",
        plotOutput(outputId = "scatter5",width='80%',height="400px")
      ),
        tabItem(tabName = "Non-Aggregate1",
        plotOutput(outputId ="nonagg",width='50%',height="900px")
      ),
       tabItem(tabName = "Aggregate1",
        sliderInput("year3","Year",min=1992,max=1998, value = 1998, step = 1),
        plotOutput(outputId = "agg",width='80%',height="450px")
      )


    )
  )
)
