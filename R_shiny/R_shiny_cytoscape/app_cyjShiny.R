if(0){
  if (!require("BiocManager", quietly = TRUE)){
    install.packages("BiocManager")
  }
  BiocManager::install("graph")
}
library(graph)
library(shiny)
library(cyjShiny)
library(jsonlite)

# NETWORK DATA ----
tbl_nodes <- data.frame(
  id=c("A", "B", "C"), 
  size=c(10, 20, 30),
  label=c("-","B","C"),
  parent=c("A","A","A"),
  stringsAsFactors=FALSE
)

# Must have the interaction column 
tbl_edges <- data.frame(
  source=c("B"),
  target=c("C"),
  interaction=c("inhibit"),
  stringsAsFactors=FALSE
)

graph_json <- toJSON(dataFramesToJSON(tbl_edges, tbl_nodes), auto_unbox=TRUE)

# UI ----
ui <- fluidPage(cyjShinyOutput('cyjShiny'))

# SERVER ----
server <- function(input, output, session) {
  output$cyjShiny <- renderCyjShiny({
    # Layouts (see js.cytoscape.org): cola, cose, circle, concentric, grid, breadthfirst, random, fcose, spread
    cyjShiny(graph_json, layoutName="cola")
  })
}

# RUN ----
shinyApp(ui=ui, server=server)