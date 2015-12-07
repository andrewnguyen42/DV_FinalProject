# server.R
require("jsonlite")
require("RCurl")
require(ggplot2)
require(shiny)
require('dplyr')
require('gridExtra')

shinyServer(function(input, output, session) {
  
  observe({
    # We'll use these multiple times, so use short var names for
    # convenience.
    c_label <- input$control_label
    updateTextInput(session, "inText",
                    label = paste("New", c_label)
    )
  })
  

    
  df <- eventReactive(input$clicks1, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
    "select * from SCHOOL;"
    ')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_cdt932', PASS='orcl_cdt932', 
    MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))
  })

    
    
    output$scatter1 <- renderPlot({
      df <- mutate(df(),DELTAMATH=as.numeric(MATH7)-as.numeric(MATH4)) %>% filter(as.numeric(as.character(GRAD)) <= 100, as.numeric(as.character(DROPOUT)) >=0);

      margin <- reactive({input$margins})

      



      plot1 <- ggplot(df,aes(x=as.numeric(LUNCH),y=as.numeric(MATH4))) +
               geom_point(shape=1) +    # Use hollow circles
               geom_smooth(method='lm',level=as.numeric(margin()))
   
      plot2 <- ggplot(df,aes(x=as.numeric(LUNCH),y=as.numeric(MATH7))) +
               geom_point(shape=1) +    # Use hollow circles
               geom_smooth(method='lm',level=as.numeric(margin()))
   
      plot3 <- ggplot(df,aes(x=as.numeric(LUNCH),y=as.numeric(DELTAMATH))) +
               geom_point(shape=1) +    # Use hollow circles
               geom_smooth(method='lm',level=as.numeric(margin()))
   
      grid.arrange(plot1,plot2,plot3,ncol=1)
    })

    output$scatter2 <- renderPlot({
      years <- reactive({input$year})
      print(years())
      df <-  filter(as.numeric(as.character(GRAD)) <= 100, as.numeric(as.character(DROPOUT)) >=0) %>% mutate(df(),DELTAMATH=as.numeric(MATH7)-as.numeric(MATH4)) %>% filter(as.numeric(as.character(YR))==years());

      margin <- reactive({input$margins2})

      



      plot1 <- ggplot(df,aes(x=as.numeric(as.character(DROPOUT)),y=as.numeric(as.character(EXPP)))) +
               geom_point(shape=1) +    # Use hollow circles
               geom_smooth(method='lm',level=as.numeric(margin()))
   
     plot1
   
    }) 

    output$scatter3 <- renderPlot({
      years <- reactive({input$year2})
      print(years())
      df <- filter(as.numeric(as.character(GRAD)) <= 100, as.numeric(as.character(DROPOUT)) >=0) %>% mutate(df(),DELTAMATH=as.numeric(MATH7)-as.numeric(MATH4)) %>% filter(as.numeric(as.character(YR))==years()) %>% filter(as.numeric(as.character(ENROL))<5000)

      margin <- reactive({input$margins2})

      



      plot1 <- ggplot(df,aes(x=as.numeric(as.character(ENROL)),y=as.numeric(as.character(DROPOUT)))) +
               geom_point(shape=1) +    # Use hollow circles
               geom_smooth(method='lm',level=as.numeric(margin()))
   
     plot1
   
    }) 

    output$scatter3 <- renderPlot({
      df <- filter(as.numeric(as.character(GRAD)) <= 100, as.numeric(as.character(DROPOUT)) >=0) %>% mutate(df(),DELTAMATH=as.numeric(MATH7)-as.numeric(MATH4)) %>% filter(as.numeric(as.character(YR))==years()) %>% filter(as.numeric(as.character(ENROL))<5000)

      



      plot1 <- ggplot(df,aes(x=as.numeric(as.character(ENROL)),y=as.numeric(as.character(DROPOUT)))) +
               geom_point(shape=1) +    # Use hollow circles
   
     plot1
   
    }) 


    output$agg <- renderPlot({
      years <- reactive({input$year3})
      df <- filter(as.numeric(as.character(GRAD)) <= 100, as.numeric(as.character(DROPOUT)) >=0) %>% mutate(df(),bin=floor((as.numeric(as.character(DROPOUT))/2)),DELTAMATH=as.numeric(MATH7)-as.numeric(MATH4)) %>% filter(as.numeric(as.character(YR))==years(),!is.null(bin)) %>% group_by(bin) %>% summarise(count=n(),avg=mean(as.numeric(as.character(EXPP))))


      



      plot1 <- ggplot(df) +
               geom_histogram(aes(x=bin,y=count),stat="identity") +
               geom_point(aes(x=bin,y=avg),stat="identity")

   
     plot1
   
    }) 
      
})
