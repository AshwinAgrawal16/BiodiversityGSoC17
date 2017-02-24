library(shiny)
library(rgbif)
source("helper.R")
ui<-fluidPage(
  # Application title
  titlePanel("GBIF occurence data plotting"),
  
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "countryInput",label=h2("Enter country (country can be IN or US)"),
       choices=(c("IN","US"))
      ),
      selectInput(
        "classKeyInput",label=h2("Enter classKey(value can be 358 or 359"),
        choices=(c("359","358"))
      )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("map")
    )
  )
)


  
  


server<-function(input,output){
  output$map <- renderPlot({
    arg1 = input$countryInput
    arg2 = input$classKeyInput
    args = list(arg1,arg2)
    #calling the function.
    do.call(map1,args)
  }
  )
  
}
  


shinyApp(ui=ui,server = server)
