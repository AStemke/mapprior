

server <- function(input, output) {

  datset_1 <- NULL
  datset_2 <- NULL
  datset_3 <- NULL
  

  output$txt_main_page                  <- renderPrint(cat(txt_main_page))
  output$txt_upload_data                <- renderPrint(cat(txt_upload_data))
  output$txt_recommended_configurations <- renderPrint(cat(txt_recommended_configurations))
  output$txt_output                     <- renderPrint(cat(txt_output))
  
  
  check <- reactiveValues(out1 = 0, out2 = 0) 
  
# Establishing the config files, that the MAP function can be used in general
  configurate <-
    reactiveValues(dat_1     = data.frame(1),  
                   dat_1_str = data.frame(1), 
                   dat_2     = data.frame(2),
                   dat_2_str = data.frame(2),
                   dat_3     = data.frame(3),
                   dat_3_str = data.frame(3)
    ) 
   
  
  
# Everything regarding the first Dataset ####
   
  data_1 <- renderTable({
    req(input$file_1)
    
    df <- read.csv(
      input$file_1$datapath,
      header = input$header,
      sep = input$sep,
      quote = input$quote
    )
    
    # Saving global, because RBesT cannot coerce reactive Dataframes
    datset_1 <<- df
    
    return(df)
    
  })
  
  # Outputs for ui_ipload and ui_nec_config
  output$data_1_0 <- data_1
  output$data_1_1 <- data_1
  
  
  observeEvent(
    c(
      input$file_1,
      input$n_arms,
      input$data_structure,
      input$data_set_1,
      input$historic_1,
      input$tau_1,
      input$tau_mean_1,
      input$sigma_1,
      input$Nc_min_1,
      input$Nc_max_1,
      input$uninf_mean_1,
      input$uninf_sigma_1,
      input$r_1,
      input$n_1,
      input$group_1
    ),
    {
      configurate$dat_1$n_arms             <- input$n_arms
      configurate$dat_1$data_set           <- input$data_set_1
      configurate$dat_1$tau                <- input$tau_1
      configurate$dat_1$tau_mean           <- input$tau_mean_1
      configurate$dat_1$sigma              <- input$sigma_1
      configurate$dat_1$rob                <- input$rob_1
      configurate$dat_1$rob_mean           <- input$rob_mean_1
      configurate$dat_1$Nc_min             <- input$Nc_min_1
      configurate$dat_1$Nc_max             <- input$Nc_max_1
      configurate$dat_1$uninf_mean         <- input$uninf_mean_1
      configurate$dat_1$uninf_sigma        <- input$uninf_sigma_1
      configurate$dat_1_str$r              <- input$r_1
      configurate$dat_1_str$n              <- input$n_1
      configurate$dat_1_str$group          <- input$group_1
      configurate$dat_1_str$data_structure <- input$data_structure
      configurate$dat_1_str$historic       <- input$historic_1
      check$out1                           <- 0
      out1                                <<- NULL                                 
    }
  )
  
  observeEvent(
    c(input$rob_1,
      input$rob_mean_1),
    {
      configurate$dat_1$rob                <- input$rob_1
      configurate$dat_1$rob_mean           <- input$rob_mean_1
    }
  )
  
  
  out1_reac <- eventReactive(input$submit_1, {
    
    if(check$out1 == 0){
      out1 <<-
        MAP.Prior.shiny(datset_1, configurate$dat_1, configurate$dat_1_str, configar = configurate$dat_1)
      check$out1 <- 1
    }else{
      print("hui")
      
      out1[[3]] <- robby(mcmc_r = out1[[1]], map_r = out1[[2]],
                         config_r = configurate$dat_1, cnfg_str_r = configurate$dat_1_str, data_r = datset_1, cret_r = configurate$dat_1)
    }
    
    out1
    
  }, ignoreInit = TRUE)
  
  output$forest_1 <- renderPlot({
    plot(out1_reac()[[1]])$`forest_model`  })
  
  
  
  output$prior_dist_1 <- renderPlot({
    plot(out1_reac()[[3]][[]])
  })
  
  
  output$dist_text_1 <- renderPrint({
    dist.text(out1_reac()[[3]])
  })
  

# Everything regarding the second Dataset ####

data_2 <- renderTable({
  req(input$file_2)
  
  df <- read.csv(
    input$file_2$datapath,
    header = input$header_2,
    sep = input$sep_2,
    quote = input$quote_2
  )
  
  # Saving global, because RBesT cannot coerce reactive Dataframes
  datset_2 <<- df
  
  return(df)
  
})

# Outputs for ui_ipload and ui_nec_config
output$data_2_0 <- data_2
output$data_2_1 <- data_2



observeEvent(
  c(
    input$file_2,
    input$n_arms,
    input$data_structure,
    input$data_set_2,
    input$historic_2,
    input$tau_2,
    input$tau_mean_2,
    input$sigma_2,
    input$Nc_min_2,
    input$Nc_max_2,
    input$uninf_mean_2,
    input$uninf_sigma_2,
    input$r_2,
    input$n_2,
    input$group_2
  ),
  {
    configurate$dat_2$n_arms             <- input$n_arms
    configurate$dat_2$data_set           <- input$data_set_2
    configurate$dat_2$tau                <- input$tau_2
    configurate$dat_2$tau_mean           <- input$tau_mean_2
    configurate$dat_2$sigma              <- input$sigma_2
    configurate$dat_2$rob                <- input$rob_2
    configurate$dat_2$rob_mean           <- input$rob_mean_2
    configurate$dat_2$Nc_min             <- input$Nc_min_2
    configurate$dat_2$Nc_max             <- input$Nc_max_2
    configurate$dat_2$uninf_mean         <- input$uninf_mean_2
    configurate$dat_2$uninf_sigma        <- input$uninf_sigma_2
    configurate$dat_2_str$r              <- input$r_2
    configurate$dat_2_str$n              <- input$n_2
    configurate$dat_2_str$group          <- input$group_2
    configurate$dat_2_str$data_structure <- input$data_structure
    configurate$dat_2_str$historic       <- input$historic_2
    check$out2                           <- 0
    out2                                <<- NULL                                 
  }
)

observeEvent(
  c(input$rob_2,
    input$rob_mean_2),
  {
    configurate$dat_2$rob                <- input$rob_2
    configurate$dat_2$rob_mean           <- input$rob_mean_2
  }
)


out2_reac <- eventReactive(input$submit_2, {
  
  if(check$out2 == 0){
    out2 <<-
      MAP.Prior.shiny(datset_2, configurate$dat_2, configurate$dat_2_str, configar = configurate$dat_1)
    check$out2 <- 1
  }else{
    print("hui")

    out2[[3]] <- robby(mcmc_r = out2[[1]], map_r = out2[[2]],
                       config_r = configurate$dat_2, cnfg_str_r = configurate$dat_2_str, data_r = datset_2, cret_r = configurate$dat_1)
  }
  
  out2
  
}, ignoreInit = TRUE)

output$forest_2 <- renderPlot({
  plot(out2_reac()[[1]])$`forest_model`  })



output$prior_dist_2 <- renderPlot({
  plot(out2_reac()[[3]][[]])
  })


output$dist_text_2 <- renderPrint({
  dist.text(out2_reac()[[3]])
  })


}
