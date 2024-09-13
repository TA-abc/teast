library(ggplot2)
library(shiny)
library(plotly)
## ref 
## https://plotly.com/r/line-and-scatter/
## https://plot.ly/r/line-charts/

## library(languageserver)

INPUT_DIR_ <- "data"
INPUT_FILE_PATHS_ <- list.files(INPUT_DIR_,full.names=T)
INPUT_FILE_PATHS_
if(0){
  write.table(x=iris,file=file.path(INPUT_DIR_,"iris.txt"), sep="\t", row.names=F, col.names=T, quote=F)
  write.table(x=mtcars,file=file.path(INPUT_DIR_,"mtcars.txt"), sep="\t", row.names=F, col.names=T, quote=F)
}

ui <- fluidPage(
  fluidRow(
    column(
      2
     ,selectInput(
        inputId = "input_file"
       ,label="Input file"
       ,choices=INPUT_FILE_PATHS_
      )
    )
  )
 ,
 fluidRow(
   column(
     2
    ,uiOutput(outputId="uiColumn_x_1")
   )
  ,
  column(
    2
    ,uiOutput(outputId="uiColumn_y_1")
  )
  ,
  column(
    2
    ,uiOutput(outputId="uiColumn_color_1")
  )
 )
 
 ,
 fluidRow(
   column(
     2
     ,uiOutput(outputId="uiColumn_x_2")
   )
   ,
   column(
     2
     ,uiOutput(outputId="uiColumn_y_2")
   )
   ,
   column(
     2
     ,uiOutput(outputId="uiColumn_color_2")
   )
 )
 
 ,fluidRow(
   column(
     6
    ,plotOutput("scat_ggplot_1")
   )
  ,column(
    6
   ,plotlyOutput("scat_plotly_1")
  )
 )
 
 ,fluidRow(
   column(
     6
     ,plotOutput("scat_ggplot_2")
   )
   ,column(
     6
     ,plotlyOutput("scat_plotly_2")
   )
 )
 
)


server = function(input, output, session){

  readData <- reactive({
    f <- input$input_file
    ## f <- "data/iris.txt"

    d <- read.table(file=f, header=T, sep="\t", stringsAsFactors=F)
    return(d)
  })

  output$uiColumn_x_1 <- renderUI({
    d <- readData()
    selectInput(
      inputId="serverColumn_x_1"
     ,label="Column x"
     ,choices=colnames(d)
    )
  })
  output$uiColumn_y_1 <- renderUI({
    d <- readData()
    selectInput(
      inputId="serverColumn_y_1"
      ,label="Column y"
      ,choices=colnames(d)
    )
  })
  output$uiColumn_color_1 <- renderUI({
    d <- readData()
    selectInput(
      inputId="serverColumn_color_1"
      ,label="Column color"
      ,choices=colnames(d)
    )
  })
  
  output$uiColumn_x_2 <- renderUI({
    d <- readData()
    selectInput(
      inputId="serverColumn_x_2"
      ,label="Column x"
      ,choices=colnames(d)
    )
  })
  output$uiColumn_y_2 <- renderUI({
    d <- readData()
    selectInput(
      inputId="serverColumn_y_2"
      ,label="Column y"
      ,choices=colnames(d)
    )
  })
  output$uiColumn_color_2 <- renderUI({
    d <- readData()
    selectInput(
      inputId="serverColumn_color_2"
      ,label="Column color"
      ,choices=colnames(d)
    )
  })
  
  
  
  
  output$scat_ggplot_1 <- renderPlot({

    d <- readData()

    column_x <- input$serverColumn_x_1
    column_y <- input$serverColumn_y_1
    column_color <- input$serverColumn_color_1
    if(0){
      column_x <- "Sepal.Width"
      column_y <- "Petal.Width"
      column_color <- "Species"
    }

    g <- ggplot(d, aes(x=.data[[column_x]], y=.data[[column_y]], color=.data[[column_color]])) + geom_point()
    
    return(g)
  })
  
  output$scat_plotly_1 <- renderPlotly({
    
    d <- readData()
    
    column_x <- input$serverColumn_x_1
    column_y <- input$serverColumn_y_1
    column_color <- input$serverColumn_color_1

    fig <- plot_ly(data = d, x = d[[column_x]], y = d[[column_y]], color = d[[column_color]])
    
    fig <- fig %>% layout(
      title = 'Styled Scatter'
     ,xaxis = list(title = column_x)
     ,xaxis = list(title = column_y)
     )
  })

  
  
  
  output$scat_ggplot_2 <- renderPlot({
    
    d <- readData()
    
    column_x <- input$serverColumn_x_2
    column_y <- input$serverColumn_y_2
    column_color <- input$serverColumn_color_2
    if(0){
      column_x <- "Sepal.Width"
      column_y <- "Petal.Width"
      column_color <- "Species"
    }
    
    g <- ggplot(d, aes(x=.data[[column_x]], y=.data[[column_y]], color=.data[[column_color]])) + geom_point()
    
    return(g)
  })
  
  output$scat_plotly_2 <- renderPlotly({
    
    d <- readData()
    
    column_x <- input$serverColumn_x_2
    column_y <- input$serverColumn_y_2
    column_color <- input$serverColumn_color_2
    
    fig <- plot_ly(data = d, x = d[[column_x]], y = d[[column_y]], color = d[[column_color]])
    
    fig <- fig %>% layout(
      title = 'Styled Scatter'
      ,xaxis = list(title = column_x)
      ,xaxis = list(title = column_y)
    )
  })
  
}

## shinyApp(ui,server, options = list(launch.browser = TRUE, display.mode ='normal'))
shinyApp(ui,server)
