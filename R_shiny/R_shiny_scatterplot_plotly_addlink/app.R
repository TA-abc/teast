## https://stackoverflow.com/questions/56084819/open-link-on-datapoint-click-with-plotly-in-r-shiny

library(plotly)
library(htmlwidgets) # to use the 'onRender' function
library(shiny)

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
)




server = function(input, output, session){
  
  readData <- reactive({
    f <- input$input_file
    ## f <- "data/iris.txt"
    
    d <- read.table(file=f, header=T, sep="\t", stringsAsFactors=F)

    d$id <- 1:nrow(d) 
    ## d$urls <- sample(size=nrow(d),x = c("http://google.com", "https://stackoverflow.com"), replace = T)
    d$urls <- paste0("http://google.com", "/", 1:nrow(d))
    
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

  output$scat_plotly_1 <- renderPlotly({
    
    d <- readData()
    
    column_x <- input$serverColumn_x_1
    column_y <- input$serverColumn_y_1
    column_color <- input$serverColumn_color_1
    
    fig <- plot_ly(
      data = d
     ,x = d[[column_x]]
     ,y = d[[column_y]]
     ,color = d[[column_color]]
     ,type = "scatter"
     ,mode = "markers"
     ,customdata = d[["urls"]]
    )
    
    js <- "
function(el, x) {
  el.on('plotly_click', function(d) {
    var point = d.points[0];
    var url = point.data.customdata[point.pointIndex];
    window.open(url);
  });
}"
    
    fig %>% onRender(js)
  })

}

shinyApp(ui,server, options = list(launch.browser = TRUE, display.mode ='normal'))
## shinyApp(ui,server)




