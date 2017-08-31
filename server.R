library(ggvis)
library(dplyr)
library(reshape2)
library(scales)


function(input, output, session) {
    moments <- reactive({
        years <- input$years
        apr <- 0.05
        y <- data.frame(1:(1+12*years))
        starting_balance <- 500000
        initial_savings <- 1500
        incremental_savings <- 10
        vol <- input$vol
        
        
        
        for (j in 1:input$simulations) {
            x <- input$balance
            bal <- x
            r <- rnorm(12*input$years, input$apr/12, vol/12)
            s <- c()
            savings <- input$savings
            for (i in 1:(12*years)) {
                x = x + savings
                x = x*(1+r[i])
                bal <- c(bal, x)
                s <- c(s,savings)
                savings <- savings + input$incremental
            }
            y[,j] = bal 
        }
        
        y$id <- 1:(1+12*years)
        data.frame(t(apply(X = y[,-(1+input$simulations)], MARGIN = 1, FUN = summary)))
    })

    
    output$plot1 <- renderPlot({
        ggplot(moments()) + 
            geom_ribbon(aes(x=1:(1+12*input$years), 
                            ymin=X1st.Qu., 
                            ymax = X3rd.Qu., 
                            alpha = 0.3), 
                        show.legend=F) + 
            geom_line(aes(1:(1+12*input$years), y = Median)) + 
            scale_y_continuous('portfolio value', labels=dollar) + 
            scale_x_continuous('months') + 
            geom_text(aes(x = 0.95*(1+12*input$years), 
                          y = moments()[(1+12*input$years),'Median'], 
                          label=dollar(moments()[(1+12*input$years),'Median']), 
                          size = 10), 
                      show.legend=F) + 
            geom_text(aes(x = 15, 
                          y = 0.8*moments()[1,'Median'], 
                          label=dollar(moments()[1,'Median']), 
                          size = 10), 
                      show.legend=F)
    })
   
    output$value <- renderText({ 
        dollar( moments()$Median[(1+12*input$years)] ) 
    })
}