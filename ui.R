my_ui <- navbarPage("My Application",
                 tabPanel("Component 1",
                          sidebarLayout(
                            sidebarPanel(
                              textInput("Input text", "text")
                            ),
                            mainPanel()
                          )),
                 tabPanel("Component 2"),
                 tabPanel("Component 3"),
                 tabPanel("Component 4")
)

shinyUI(my_ui)