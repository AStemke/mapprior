server <- function(input, output, session) {
  # Initializing necessary variables and the texts ####
  datset_1 <- NULL
  datset_2 <- NULL
  datset_3 <- NULL
  
  
  output$txt_main_page                  <-
    renderPrint(cat(txt_main_page))
  output$txt_upload_data                <-
    renderPrint(cat(txt_upload_data))
  output$txt_recommended_configurations <-
    renderPrint(cat(txt_recommended_configurations))
  output$txt_output                     <-
    renderPrint(cat(txt_output))
  output$txt_help                       <- 
    renderPrint(cat(txt_help))
  output$gen_info                       <- 
    renderText(input$endpoint_type) 
  
  check <- reactiveValues(out1 = 0, out2 = 0)
  
  
  # Regarding the Help File
  url <- a("User Manual", target="_blank", href="Manual.pdf")
  output$help <- renderUI({
    tagList("File link:", url)
  })
  
  # Establishing the config files, that the MAP function can be used in general
  configurate <-
    reactiveValues(
      dat_1      = data.frame(1),
      dat_1_str  = data.frame(1),
      dat_1_mcmc = data.frame(1),
      dat_2      = data.frame(2),
      dat_2_str  = data.frame(2),
      dat_2_mcmc = data.frame(2),
      dat_3      = data.frame(3),
      dat_3_str  = data.frame(3),
      dat_3_mcmc = data.frame(3)
    )
  
  
  
  note <- reactiveValues(
    err_1 = NULL,
    err_2 = NULL,
    war_1 = NULL,
    war_2 = NULL,
    msg_1 = NULL,
    msg_2 = NULL
  )
  
  #default to put in data manually in ui_upload
  
  default <-   eventReactive(input$endpoint_type,
                             {
                               if (input$endpoint_type == "Binary") {
                                 default <-
                                   data.frame("study" = character(1),
                                              "n" = numeric(1),
                                              "r" = numeric(1))
                               }
                               if (input$endpoint_type == "Normal") {
                                 default <-
                                   data.frame("study" = character(1),
                                              "n" = numeric(1),
                                              "y" = numeric(1))
                               }
                               if (input$endpoint_type == "TTE") {
                                 default <-
                                   data.frame(
                                     "study" = character(1),
                                     "eventsobs" = 1,
                                     "hr" = 1,
                                     "k" = 1
                                   )
                               }
                               return(default)
                             },
                             ignoreNULL = FALSE,
                             ignoreInit = FALSE)
  
  # Delivers settings for the recommendation of tau
  
  heterogeneity   <-
    c("small", "substantial", "large", "very large")
  ratio_tau_sigma <- c(0.0625, 0.125, 0.5, 1)
  
  
  
  # Everything regarding the first Dataset ####
  
  # Delivers some recommendations for tau
  
  tau_info_1 <-
    eventReactive(
      c(
        input$csv_file_1,
        input$rds_file_1,
        input$endpoint_type,
        input$sigma_1,
        input$data_out_1,
        input$r_1,
        input$n_1,
        input$group_1,
        input$endpoint_type,
        input$historic_1,
        input$study_1,
        input$n_binary_1,
        input$n_normal_1,
        input$r_1,
        input$y_1,
        input$hr_1,
        input$k_1,
        input$eventsobs_1
      ),
      {
        wip_1 <- MAP.set.default(datset_1(), configurate$dat_1, configurate$dat_1_str)
        data_1 <- as.data.frame(wip_1[[1]])
        configurate$dat_1 <- wip_1[[2]]
        Tau_Prior <- if (!is.na(configurate$dat_1$sigma)) {
          ratio_tau_sigma * configurate$dat_1$sigma
        } else{
          if (!is.na(configurate$dat_1$uninf_sigma)) {
            ratio_tau_sigma * configurate$dat_1$uninf_sigma
          } else{
            "A valid standard deviation is missing"
          }
        }
        recom <-
          data.frame(cbind(heterogeneity, ratio_tau_sigma, round(Tau_Prior, 4)))
        names(recom) <- c("Heterogeneity", "Tau/Sigma", "Tau Prior")
        return(recom)
      }
    )
  
  output$tau_recom_1 <-  renderTable(tau_info_1())
  
  
  
  # Upload the first Dataset
  data_up_1 <-
    eventReactive(c(input$csv_file_1,
                    input$rds_file_1,
                    input$csv_header_1,
                    input$csv_sep_1,
                    input$csv_quote_1),
                  {
                    if(input$format_1 == "RDS"){
                      df <- readRDS(input$rds_file_1$datapath)
                    }
                    if(input$format_1 == "CSV"){
                      df <- read.csv(
                        input$csv_file_1$datapath,
                        header = input$csv_header_1,
                        sep = input$csv_sep_1,
                        quote = input$csv_quote_1
                      )
                    }
                    return(df)
                  })
  
  
  
  # Create reacitve Data, for R handsom and read in the default, if no Data is uploaded
  data_reac_1 <- reactive({
    
    if(input$format_1 == "RDS"){
      if (is.null(input$rds_file_1)) {
        # if no data was uploaded: show default data
        ds_1 <- default()
      } else{
        # if data was uploaded: show uploaded data
        ds_1 <- data_up_1()
      }
    }
    
    if(input$format_1 == "CSV"){
      if (is.null(input$csv_file_1)) {
        # if no data was uploaded: show default data
        ds_1 <- default()
      } else{
        # if data was uploaded: show uploaded data
        ds_1 <- data_up_1()
      }
    }
    
    return(ds_1)
    
  })
  
  # also generates input$data_out_1
  output$data_out_1 <- renderRHandsontable({
    rhandsontable(data_reac_1(),
                  rowHeaders = NULL,
                  readOnly = FALSE)
  })
  
  
  datset_1 <-  eventReactive(input$data_out_1, {
    hot_to_r(input$data_out_1)
  })
  
  
  observeEvent(
    c(
      input$csv_file_1,
      input$rds_file_1,
      input$n_arms,
      input$endpoint_type,
      input$data_set_1,
      input$historic_1,
      input$weight_1,
      input$tau_1,
      input$tau_mean_1,
      input$sigma_1,
      input$Nc_min_1,
      input$Nc_max_1,
      input$uninf_mean_binary_1,
      input$uninf_mean_normal_1,
      input$uninf_mean_tte_1,
      input$uninf_sigma_normal_1,
      input$uninf_sigma_tte_1,
      input$study_1,
      input$n_binary_1,
      input$n_normal_1,
      input$r_1,
      input$y_1,
      input$hr_1,
      input$k_1,
      input$eventsobs_1,
      input$data_out_1,
      input$seed_1,
      input$user_mcmc_1,
      input$reprod_1,
      input$warmup_1,
      input$iter_1,
      input$delta_1,
      input$stepsize_1,
      input$treedepth_1
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
      configurate$dat_1_str$r              <- input$r_1
      configurate$dat_1_str$group          <- input$group_1
      configurate$dat_1_str$endpoint_type  <- input$endpoint_type
      configurate$dat_1_str$historic       <- input$historic_1
      configurate$dat_1_str$study          <- input$study_1
      configurate$dat_1_str$weight         <- input$weight_1
      configurate$dat_1_str$r              <- input$r_1
      configurate$dat_1_str$y              <- input$y_1
      configurate$dat_1_str$hr             <- input$hr_1
      configurate$dat_1_str$k              <- input$k_1
      configurate$dat_1_str$eventsobs      <- input$eventsobs_1
      configurate$dat_1_mcmc$seed          <- input$seed_1
      configurate$dat_1_mcmc$user_mcmc     <- input$user_mcmc_1
      configurate$dat_1_mcmc$reprod        <- input$reprod_1
      configurate$dat_1_mcmc$warmup        <- input$warmup_1
      configurate$dat_1_mcmc$iter          <- input$iter_1
      configurate$dat_1_mcmc$delta         <- input$delta_1
      configurate$dat_1_mcmc$stepsize      <- input$stepsize_1
      configurate$dat_1_mcmc$treedepth     <- input$treedepth_1
      if(input$endpoint_type == "Binary"){
        configurate$dat_1$uninf_mean       <- input$uninf_mean_binary_1
        configurate$dat_1_str$n            <- input$n_binary_1
      }
      if(input$endpoint_type == "Normal"){
        configurate$dat_1$uninf_mean       <- input$uninf_mean_normal_1
        configurate$dat_1$uninf_sigma      <- input$uninf_sigma_normal_1
        configurate$dat_1_str$n            <- input$n_normal_1
      }
      if(input$endpoint_type == "TTE"){
        configurate$dat_1$uninf_mean       <- input$uninf_mean_tte_1
        configurate$dat_1$uninf_sigma      <- input$uninf_sigma_tte_1
      }
      check$out1                           <- 0
      out1                                <<-
        NULL
    }
  )
  
  
  
  observeEvent(c(input$rob_1,
                 input$rob_mean_1),
               {
                 configurate$dat_1$rob                <- input$rob_1
                 configurate$dat_1$rob_mean           <-
                   input$rob_mean_1
               })
  
  
  out1_reac <- eventReactive(input$submit_1, {
    if (check$out1 == 0) {
      
      
      out1 <<- withCallingHandlers({
          note$err_1 <- NULL
          note$war_1 <- NULL
          note$msg_1 <- NULL
          MAP.Prior.shiny(
            datset_1(),
            configurate$dat_1,
            configurate$dat_1_str,
            mcmc_cnfg = configurate$dat_1_mcmc)
        }, error = function(e){
          note$err_1 <- e
        }, warning = function(w){
          note$war_1 <- paste0("Warning ",gsub("^.*?:",":", w))
        }, message = function(m){
          note$msg_1 <- paste0("Message ",gsub("^.*?:",":", m))
          if(note$msg_1 == 'Message : \", paste(beta.prior.location, : Assuming default prior location   for beta: 0\n\n'){
            note$msg_1 <- "Assuming default prior location for beta: 0"
          }
        })
      
      
      
      # out1 <<- MAP.Prior.shiny(
      #   datset_1(),
      #   configurate$dat_1,
      #   configurate$dat_1_str,
      #   mcmc_cnfg = configurate$dat_1_mcmc)
      
      check$out1 <- 1
      
    } else{
      
      # 1.mcmc, 2.map, 3.rob, 4.config, 5.cnfg_str, 6.mcmc_cnfg, 7.configar, 8.gonogo
      
      out1[[3]] <<- robby(
        mcmc_r = out1[[1]],
        map_r = out1[[2]],
        config_r = configurate$dat_1,
        cnfg_str_r = configurate$dat_1_str,
        data_r = datset_1(),
        cret_r = configurate$dat_1
      )
      
      out1[[8]] <<- gonogo_ui(rob = out1[[3]], cnfg_str = configurate$dat_1_str, round = TRUE)
      
    }
    
    out1
    
  }, ignoreInit = TRUE)
  
  
  # Problem: only the last message is print out
  output$error_1   <- renderText(note$err_1)
  output$warning_1 <- renderText(note$war_1)
  output$message_1 <- renderText(note$msg_1)
  
  observe({
    if(!is.null(note$war_1)){
      warn_text_1 <- "Warning: Pay attention to severe issues with the first MAP Prior!"
      js_string_1 <- 'alert("WARNING");'
      js_string_1 <- sub("WARNING",warn_text_1,js_string_1)
      session$sendCustomMessage(type='jsCode', list(value = js_string_1))
    }
  })
  
  
  
  output$forest_1 <- renderPlot({
    plot(out1_reac()[[1]])$`forest_model`
  })
  
  
  
  output$prior_dist_1 <- renderPlot({
    plot(out1_reac()[[3]][[]])
  })
  
  
  output$dist_text_1 <- renderPrint({
    dist.text(out1_reac()[[3]])
  })
  
  
  # Everything regarding the second Dataset ####
  
  # Delivers some recommendations for tau
  
  
  tau_info_2 <-
    eventReactive(
      c(
        input$csv_file_2,
        input$rds_file_2,
        input$endpoint_type,
        input$sigma_2,
        input$data_out_2,
        input$r_2,
        input$n_2,
        input$group_2,
        input$endpoint_type,
        input$historic_2,
        input$study_2,
        input$n_binary_2,
        input$n_normal_2,
        input$r_2,
        input$y_2,
        input$hr_2,
        input$k_2,
        input$eventsobs_2
      ),
      {
        wip_2 <- MAP.set.default(datset_2(), configurate$dat_2, configurate$dat_2_str)
        data_2 <- as.data.frame(wip_2[[1]])
        configurate$dat_2 <- wip_2[[2]]
        is.na(configurate$dat_2$sigma)
        is.na(configurate$dat_2$uninf_sigma)
        Tau_Prior <- if (!is.na(configurate$dat_2$sigma)){
          ratio_tau_sigma * configurate$dat_2$sigma
        } else{
          if (!is.na(configurate$dat_2$uninf_sigma)){
            ratio_tau_sigma * configurate$dat_2$uninf_sigma
          } else{
            "A valid standard deviation is missing"
          }
        }
        recom <-
          data.frame(cbind(heterogeneity, ratio_tau_sigma, round(Tau_Prior, 4)))
        names(recom) <- c("Heterogeneity", "Tau/Sigma", "Tau Prior")
        return(recom)
      }
    )
  
  output$tau_recom_2 <-  renderTable(tau_info_2())
  
  
  # Upload the second Dataset
  data_up_2 <-
    eventReactive(c(input$csv_file_2,
                    input$rds_file_2,
                    input$csv_header_2,
                    input$csv_sep_2,
                    input$csv_quote_2),
                  {
                    if(input$format_2 == "RDS"){
                      df <- readRDS(input$rds_file_2$datapath)
                    }
                    if(input$format_2 == "CSV"){
                      df <- read.csv(
                        input$csv_file_2$datapath,
                        header = input$csv_header_2,
                        sep = input$csv_sep_2,
                        quote = input$csv_quote_2
                      )
                    }
                    return(df)
                  })
  
  
  
  # Create reacitve Data, for R handsom and read in the default, if no Data is uploaded
  
  
  data_reac_2 <- reactive({
    
    if(input$format_2 == "RDS"){
      if (is.null(input$rds_file_2)) {
        # if no data was uploaded: show default data
        ds_2 <- default()
      } else{
        # if data was uploaded: show uploaded data
        ds_2 <- data_up_2()
      }
    }
    
    if(input$format_2 == "CSV"){
      if (is.null(input$csv_file_2)) {
        # if no data was uploaded: show default data
        ds_2 <- default()
      } else{
        # if data was uploaded: show uploaded data
        ds_2 <- data_up_2()
      }
    }
    
    return(ds_2)
    
  })
  
  
  
  # also generates input$data_out_2
  output$data_out_2 <- renderRHandsontable({
    rhandsontable(data_reac_2(),
                  rowHeaders = NULL,
                  readOnly = FALSE)
    
  })
  
  
  
  datset_2 <-  eventReactive(input$data_out_2, {
    hot_to_r(input$data_out_2)
  })
  

  
  observeEvent(
    c(
      input$file_2,
      input$n_arms,
      input$endpoint_type,
      input$data_set_2,
      input$historic_2,
      input$weight_2,
      input$tau_2,
      input$tau_mean_2,
      input$sigma,
      input$Nc_min_2,
      input$Nc_max_2,
      input$uninf_mean_binary_2,
      input$uninf_mean_normal_2,
      input$uninf_mean_tte_2,
      input$uninf_sigma_normal_2,
      input$uninf_sigma_tte_2,
      input$study_2,
      input$n_binary_2,
      input$n_normal_2,
      input$r_2,
      input$y_2,
      input$hr_2,
      input$k_2,
      input$eventsobs_2,
      input$data_out_2,
      input$seed_2,
      input$user_mcmc_2,
      input$reprod_2,
      input$warmup_2,
      input$iter_2,
      input$delta_2,
      input$stepsize_2,
      input$treedepth_2
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
      configurate$dat_2_str$endpoint_type  <- input$endpoint_type
      configurate$dat_2_str$historic       <- input$historic_2
      configurate$dat_2_str$study          <- input$study_2
      configurate$dat_2_str$weight         <- input$weight_2
      configurate$dat_2_str$r              <- input$r_2
      configurate$dat_2_str$y              <- input$y_2
      configurate$dat_2_str$hr             <- input$hr_2
      configurate$dat_2_str$k              <- input$k_2
      configurate$dat_2_str$eventsobs      <- input$eventsobs_2
      configurate$dat_2_mcmc$seed          <- input$seed_2
      configurate$dat_2_mcmc$user_mcmc     <- input$user_mcmc_2
      configurate$dat_2_mcmc$reprod        <- input$reprod_2
      configurate$dat_2_mcmc$warmup        <- input$warmup_2
      configurate$dat_2_mcmc$iter          <- input$iter_2
      configurate$dat_2_mcmc$delta         <- input$delta_2
      configurate$dat_2_mcmc$stepsize      <- input$stepsize_2
      configurate$dat_2_mcmc$treedepth     <- input$treedepth_1
      if(input$endpoint_type == "Binary"){
        configurate$dat_2$uninf_mean       <- input$uninf_mean_binary_2
        configurate$dat_2_str$n            <- input$n_binary_2
      }
      if(input$endpoint_type == "Normal"){
        configurate$dat_2$uninf_mean       <- input$uninf_mean_normal_2
        configurate$dat_2$uninf_sigma      <- input$uninf_sigma_normal_2
        configurate$dat_2_str$n            <- input$n_normal_2
      }
      if(input$endpoint_type == "TTE"){
        configurate$dat_2$uninf_mean       <- input$uninf_mean_tte_2
        configurate$dat_2$uninf_sigma      <- input$uninf_sigma_tte_2
      }
      check$out2                           <- 0
      out2                                <<-
        NULL
    }
  )
  
  
  observeEvent(c(input$rob_2,
                 input$rob_mean_2),
               {
                 configurate$dat_2$rob                <- input$rob_2
                 configurate$dat_2$rob_mean           <-
                   input$rob_mean_2
               })
  
  
  out2_reac <- eventReactive(input$submit_2, {
    if (check$out2 == 0) {
      
      out2 <<- withCallingHandlers({
          note$err_2 <- NULL
          note$war_2 <- NULL
          note$msg_2 <- NULL
          MAP.Prior.shiny(
            datset_2(),
            configurate$dat_2,
            configurate$dat_2_str,
            mcmc_cnfg = configurate$dat_2_mcmc)
        }, error = function(e){
          note$err_2 <- e
        }, warning = function(w){
          note$war_2 <- paste0("Warning ",gsub("^.*?:",":", w))
        }, message = function(m){
          note$msg_2 <- paste0("Message ",gsub("^.*?:",":", m))
          if(note$msg_2 == 'Message : \", paste(beta.prior.location, : Assuming default prior location   for beta: 0\n\n'){
            note$msg_2 <- "Assuming default prior location for beta: 0"
          }
        })
      
      
      # out2 <<-
      #   MAP.Prior.shiny(datset_2(),
      #                   configurate$dat_2,
      #                   configurate$dat_2_str,
      #                   mcmc_cnfg = configurate$dat_2_mcmc)
      
      
      check$out2 <- 1
      
    } else{
      out2[[3]] <<- robby(
        mcmc_r = out2[[1]],
        map_r = out2[[2]],
        config_r = configurate$dat_2,
        cnfg_str_r = configurate$dat_2_str,
        data_r = datset_2(),
        cret_r = configurate$dat_2
      )
      
      out2[[8]] <<- gonogo_ui(rob = out2[[3]], cnfg_str = configurate$dat_2_str, round = TRUE)
    }
    
    out2
    
  }, ignoreInit = TRUE)
  
  
  # Problem: only the last message is print out
  output$error_2   <- renderText(note$err_2)
  output$warning_2 <- renderText(note$war_2)
  output$message_2 <- renderText(note$msg_2)
  
  observe({
    if(!is.null(note$war_2)){
      warn_text_2 <- "Warning: Pay attention to severe issues with the second MAP Prior!"
      js_string_2 <- 'alert("WARNING");'
      js_string_2 <- sub("WARNING",warn_text_2,js_string_2)
      session$sendCustomMessage(type='jsCode', list(value = js_string_2))
    }
  })
  
  
  output$forest_2 <- renderPlot({
    plot(out2_reac()[[1]])$`forest_model`
  })
  
  
  output$prior_dist_2 <- renderPlot({
    plot(out2_reac()[[3]][[]])
  })
  
  
  output$dist_text_2 <- renderPrint({
    dist.text(out2_reac()[[3]])
  })
  
  
  ##### Code Parts including in Report
  
  # 1.mcmc, 2.map, 3.rob, 4.config, 5.cnfg_str, 6.mcmc_cnfg, 7.configar, 8. gonogo
  output$detail_1_2   <- renderPrint(print(out1_reac()[[2]]))
  output$detail_2_2   <- renderPrint(print(out2_reac()[[2]]))
  output$detail_1_4   <- renderPrint(print(out1_reac()[[6]]))
  output$detail_2_4   <- renderPrint(print(out2_reac()[[6]]))
  output$detail_1_1   <- renderPrint(print(out1_reac()[[1]]))
  output$detail_2_1   <- renderPrint(print(out2_reac()[[1]]))
  output$detail_1_3   <- renderPrint(print(out1_reac()[[3]]))
  output$detail_2_3   <- renderPrint(print(out2_reac()[[3]]))
  output$detail_1_5_1 <- renderPrint(print(out1_reac()[[4]]))
  output$detail_2_5_1 <- renderPrint(print(out2_reac()[[4]]))
  output$detail_1_5_2 <- renderPrint(print(out1_reac()[[5]]))
  output$detail_2_5_2 <- renderPrint(print(out2_reac()[[5]]))
  output$detail_1_6   <- renderPrint(print(out1_reac()[[8]]))
  output$detail_2_6   <- renderPrint(print(out2_reac()[[8]]))
  
  
  
  
  
  output$report <- downloadHandler(
    # For PDF output, change this to "report.pdf" and change it in "MAP_Report.Rmd"
    filename = "report.docx",
    content = function(file) {
      tempReport <- file.path(tempdir(), "MAP_Report.Rmd")
      file.copy("MAP_Report.Rmd", tempReport, overwrite = TRUE)
      

      # Set up parameters to pass to Rmd document
      params <- list(
        out1 = out1,
        out2 = out2,
        struc = input$endpoint_type,
        n_arms = input$n_arms,
        historic_1 = input$historic_1,
        historic_2 = input$historic_2,
        detail_0 = input$detail_0,
        detail_1 = input$detail_1,
        detail_2 = input$detail_2,
        detail_3 = input$detail_3,
        detail_4 = input$detail_4,
        detail_5 = input$detail_5,
        detail_6 = input$detail_6,
        err_1 = note$err_1,
        err_2 = note$err_2,
        war_1 = note$war_1,
        war_2 = note$war_2,
        msg_1 = note$msg_1,
        msg_2 = note$msg_2
      )
      

      # Knit the document, passing in the `params` and 'settings' list, and eval it in a
      # child of the global environment (this isolates the code in the document
      # from the code in this app).
      rmarkdown::render(
        tempReport,
        output_file = file,
        params = params,
        envir = new.env(parent = globalenv())
      )
    }
  )
}


# To improve: output all errors, warnings and messages, not only the first
# To improve no overscoping (out1 and out2), but to robustify cannot overwrite a reactive Value
