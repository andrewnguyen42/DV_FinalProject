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
               geom_smooth(method='lm',level=as.numeric(margin())) +
               labs(x="% Elligible For Free Lunch",y="4th Grade Math Score")
   
      plot2 <- ggplot(df,aes(x=as.numeric(LUNCH),y=as.numeric(MATH7))) +
               geom_point(shape=1) +    # Use hollow circles
               geom_smooth(method='lm',level=as.numeric(margin())) +
               labs(x="% Elligible For Free Lunch",y="7th Grade Math Score")
   
      plot3 <- ggplot(df,aes(x=as.numeric(LUNCH),y=as.numeric(DELTAMATH))) +
               geom_point(shape=1) +    # Use hollow circles
               geom_smooth(method='lm',level=as.numeric(margin()))+
               labs(x="Lunch Expenditure",y="Delta Math Score")
   
      grid.arrange(plot1,plot2,plot3,ncol=1)
    })

    output$scatter2 <- renderPlot({
      years <- reactive({input$year})
      print(years())
      df <-  filter(df(),as.numeric(as.character(GRAD)) <= 100, as.numeric(as.character(DROPOUT)) >=0) %>% mutate(DELTAMATH=as.numeric(MATH7)-as.numeric(MATH4)) %>% filter(as.numeric(as.character(YR))==years());

      margin <- reactive({input$margins2})

      



      plot1 <- ggplot(df,aes(x=as.numeric(as.character(DROPOUT)),y=as.numeric(as.character(EXPP)))) +
               geom_point(shape=1) +    # Use hollow circles
               geom_smooth(method='lm',level=as.numeric(margin())) +
               labs(x="Dropout Rate",y="Expenditures Per Pupil")
   
     plot1
   
    }) 

    output$scatter3 <- renderPlot({
      years <- reactive({input$year2})
      df <- filter(df(),as.numeric(as.character(GRAD)) <= 100, as.numeric(as.character(DROPOUT)) >=0) %>% mutate(DELTAMATH=as.numeric(MATH7)-as.numeric(MATH4)) %>% filter(as.numeric(as.character(YR))==years()) %>% filter(as.numeric(as.character(ENROL))<5000)

      margin <- reactive({input$margins2})

      



      plot1 <- ggplot(df,aes(x=as.numeric(as.character(ENROL)),y=as.numeric(as.character(DROPOUT)))) +
               geom_point(shape=1) +    # Use hollow circles
               geom_smooth(method='lm',level=as.numeric(margin())) +
               labs(x="Enrollment",y="Dropout Rate")
   
     plot1
   
    }) 

    output$scatter4 <- renderPlot({
      years <- reactive({input$year3})
      df <-  filter(df(),as.numeric(as.character(GRAD)) <= 100, as.numeric(as.character(DROPOUT)) >=0) %>% mutate(DELTAMATH=as.numeric(MATH7)-as.numeric(MATH4)) %>% filter(as.numeric(as.character(YR))==years());

      margin <- reactive({input$margins3})

      
      plot1 <- ggplot(df,aes(x=as.numeric(as.character(AVGSAL)),y=as.numeric(as.character(MATH7)))) +
               geom_point(shape=1) +    # Use hollow circles
               geom_smooth(method='lm',level=as.numeric(margin())) +
               labs(x="Average Teacher Salary",y="7th Grade Math Scores")
   
      plot1
   
    }) 

    output$scatter5 <- renderPlot({
      df <-  filter(df(),as.numeric(as.character(GRAD)) <= 100, as.numeric(as.character(DROPOUT)) >=0) %>% mutate(DELTAMATH=as.numeric(MATH7)-as.numeric(MATH4)) %>% filter(as.numeric(as.character(ENROL))<50000);

      plot1 <- ggplot(df,aes(x=as.numeric(as.character(REXPP)),y=as.numeric(as.character(MATH4)),color=as.numeric(as.character(DROPOUT)),size=as.numeric(as.character(ENROL)))) +
               geom_point(shape=1) +
               labs(x="Expenditures Per Puplil",y="4th Grade Math Scores")
   
     plot1
   
    }) 


    output$nonagg <- renderPlot({
      df <- filter(df(),as.numeric(as.character(GRAD)) <= 100, as.numeric(as.character(DROPOUT)) >=0) %>% mutate(DELTAMATH=as.numeric(as.character(MATH7))-as.numeric(as.character(MATH4))) %>% filter(as.numeric(as.character(ENROL))<5000)

      



      plot1 <- ggplot(df,aes(factor(YR),as.numeric(as.character(MATH4)))) +
               geom_boxplot() + 
               labs(x="Year",y="4th Grade Math Scores") 
      plot2 <- ggplot(df,aes(factor(YR),as.numeric(as.character(MATH7)))) +
               geom_boxplot() +
               labs(x="Year",y="7th Grade Math Scores") 
      plot3 <- ggplot(df,aes(factor(YR),as.numeric(as.character(DELTAMATH)))) +
               geom_boxplot() +
               labs(x="Year",y="Delta Math Scores") 
   

      grid.arrange(plot1,plot2,plot3,ncol=1)
   
    }) 


    output$agg <- renderPlot({
      years <- reactive({input$year3})
      df <- filter(df(),as.numeric(as.character(GRAD)) <= 100, as.numeric(as.character(DROPOUT)) >=0) %>% mutate(bin=floor((as.numeric(as.character(DROPOUT))/2)),DELTAMATH=as.numeric(MATH7)-as.numeric(MATH4)) %>% filter(as.numeric(as.character(YR))==years(),!is.null(bin)) %>% group_by(bin) %>% summarise(count=n(),avg=mean(as.numeric(as.character(EXPP))))


      

      grid.newpage()

      plot1 <- ggplot(df) +
               geom_histogram(aes(x=bin,y=count),stat="identity") +
               theme_bw()
      plot2 <- ggplot(df) +
               geom_point(aes(x=bin,y=avg),stat="identity",color="blue",size=5) +
               theme_bw() %+replace%
               theme(panel.background = element_rect(fill = NA))
      
      g1 <- ggplot_gtable(ggplot_build(plot1))
      g2 <- ggplot_gtable(ggplot_build(plot2))

      # overlap the panel of 2nd plot on that of 1st plot
      pp <- c(subset(g1$layout, name == "panel", se = t:r))
      g <- gtable_add_grob(g1, g2$grobs[[which(g2$layout$name == "panel")]], pp$t, 
        pp$l, pp$b, pp$l)

      # axis tweaks
      ia <- which(g2$layout$name == "axis-l")
      ga <- g2$grobs[[ia]]
      ax <- ga$children[[2]]
      ax$widths <- rev(ax$widths)
      ax$grobs <- rev(ax$grobs)
      ax$grobs[[1]]$x <- ax$grobs[[1]]$x - unit(1, "npc") + unit(0.15, "cm")
      g <- gtable_add_cols(g, g2$widths[g2$layout[ia, ]$l], length(g$widths) - 1)
      g <- gtable_add_grob(g, ax, pp$t, length(g$widths) - 1, pp$b)

      grid.draw(g)
   
   
    }) 
      
})
