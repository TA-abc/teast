library(shiny)
library(shinyCyJS)

ui = function(){
  fluidPage(
    ShinyCyJSOutput(outputId = 'cy')
  )
}

server = function(input, output, session){  
  reactive_nodes <- reactive({
    nodes = data.frame(
      id = c('A','B','C','D'),
      width = c(10,20,30,40),
      label=c('','B','C','D'),
      height = c(10,20,30,40),
      shape=c("triangle","triangle","round-triangle","rectangle"),
      parent = c('A','A','A','D'),
      bgColor=c("#555555","#EE0000","#00EE00","#0000EE")
    )
  })
    
  reactive_edges <- reactive({
    edges = data.frame(
      source = c('B','C','D'),
      target = c('C','D','B')
    )
  })
  output$cy = renderShinyCyJS({
    nodes <- reactive_nodes()
    edges <- reactive_edges()
    
    nodes <- buildElems(nodes, type = 'Node')
    edges <- buildElems(edges, type = 'Edge')  
    
    obj <- shinyCyJS(c(nodes, edges))
    obj
  })
}

shinyApp(ui,server, options = list(launch.browser = TRUE, display.mode ='normal'))
