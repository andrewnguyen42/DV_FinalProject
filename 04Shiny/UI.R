#ui.R

require(shiny)
require(shinydashboard)
require(leaflet)

dashboardPage(
  dashboardHeader(title="Final Project"
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Scatter1", tabName = "scatter1"),
      menuItem("Scatter2", tabName = "scatter2"),
      menuItem("Scatter3", tabName = "scatter3"),
      menuItem("Aggregate1", tabName = "Aggregate1")
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "scatter1",
        actionButton(inputId = "clicks1",  label = "Update Data"),
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
       tabItem(tabName = "Aggregate1",
        sliderInput("year3","Year",min=1992,max=1998, value = 1998, step = 1),
        plotOutput(outputId = "agg",width='80%',height="450px")
      )


    )
  )
)
