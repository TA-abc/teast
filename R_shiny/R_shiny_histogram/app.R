library(ggplot2)
library(shiny)
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
   , 
    column(
      2
     ,numericInput(
        inputId = "binwidth"
       ,label="binwidth"
       ,value=0.1
       ,min=0.01
       ,max=10
       ,step=0.01
      )
    )
  )
 ,
 fluidRow(
   column(
     2
    ,uiOutput(outputId="uiColumn")
   )
  )


  ,plotOutput("histogram")
)


server = function(input, output, session){

  readData <- reactive({
    f <- input$input_file
    ## f <- "data/iris.txt"

    d <- read.table(file=f, header=T, sep="\t", stringsAsFactors=F)
    return(d)
  })

  output$uiColumn <- renderUI({
    d <- readData()
    selectInput(
      inputId="serverColumn"
     ,label="Column"
     ,choices=colnames(d)
    )
  })

  output$histogram <- renderPlot({

    d <- readData()

    column_name <- input$serverColumn
    binwidth <- input$binwidth
    if(0){
      column_name <- "Sepal.Width"
      binwidth <- 1
    }

    g <- ggplot(d, aes(x=.data[[column_name]])) + geom_histogram(binwidth=binwidth)

    return(g)
  })

}

## shinyApp(ui,server, options = list(launch.browser = TRUE, display.mode ='normal'))
shinyApp(ui,server)
