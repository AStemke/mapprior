

MAP.Prior.shiny <- function(data, config, cnfg_str, configar = configurate$dat_1){  

  # data is the dataset for the MAP prior is generated
  # config is the config data according to the dataset
  # cnfg_str has all the structure (string) config elements to the according dataset
  # configar is the config data from which other data can borrow information,
  #         if nothing else is available (see retrieve.config),
  #          it has to be given again at serverside and sadly cannot be
  #          predefined as configurate$dat_1 in the function
  
    
  # Different cases for historic Data input exists or not
  
  if(cnfg_str$historic == TRUE){
    if(cnfg_str$data_structure == "Binary"){
      #Default if no recommended configuration is provided
      if(is.na(config$tau)){
        config$tau <- 1
      }
      if(is.na(config$sigma)){
        config$sigma <- 2
      }
      mcmc <- gMAP(cbind(n, n-r) ~ 1 | study,
                   data = data,
                   family = binomial,
                   tau.dist = "HalfNormal",
                   tau.prior = config$tau,
                   beta.prior = config$sigma)
      
      map <- automixfit(mcmc, type = "beta", Nc = config$Nc_min:config$Nc_max)
      
      
    }
    if(cnfg_str$data_structure == "Normal"){
      if(is.na(config$sigma)){
        config$sigma <- 100*sd(data$y)
      }
      if(is.na(config$tau)){
        config$tau <- config$sigma/2
      }
      data$y.se <- config$sigma/sqrt(data$n)
      mcmc <- gMAP(cbind(y, y.se) ~ 1 | study, 
                   weights = n,
                   data=data,
                   family = gaussian,
                   tau.dist ="HalfNormal",
                   tau.prior = cbind(0, config$tau),
                   beta.prior = cbind(0, config$sigma))
      map <- automixfit(mcmc, type = "norm", Nc = config$Nc_min:config$Nc_max)
      
    }
    if(cnfg_str$data_structure == "TTE"){
      # transformation for log normal
      data$log.hr <- log(data$hr)
      if(is.na(config$sigma)){
        config$sigma <- 100*sd(data$log.hr)
      }
      if(is.na(config$tau)){
        config$tau <- config$sigma/2
      }
      #se formular equivalent to gonogo app
      data$log.hr.se <- sqrt((data$k+1)^2/(data$k*data$eventsobs))
      mcmc <- gMAP(cbind(log.hr, log.hr.se) ~ 1 | study, 
                   weights = data$eventsobs,
                   data=data,
                   family = gaussian,
                   tau.dist ="HalfNormal",
                   tau.prior = cbind(0, config$tau),
                   beta.prior = cbind(0, config$sigma))
      map <- automixfit(mcmc, type = "norm", Nc = config$Nc_min:config$Nc_max)
      
    }
  }else{
    #for flat priors (no historic information provided)
    
    if(cnfg_str$data_structure == "Binary"){
      config <- retrieve.config(config, "uninf_mean", stand = 0.5, cret = configar)
      map <- mixbeta(Uninf = c(1, config$uninf_mean, 2), param = "mn")
      mcmc <- NULL
    }
    if(cnfg_str$data_structure == "Normal"){
      config <- retrieve.config(config, "uninf_mean", stand = 0, cret = configar)
      map <- mixnorm(Uninf = c(1, config$uninf_mean, 2), param = "mn", sigma = config$uninf_sigma)
      mcmc <- NULL
    }
    if(cnfg_str$data_structure == "TTE"){
      config <- retrieve.config(config, c("rob_mean"), stand = 0, cret = configar)
      map <- mixnorm(Uninf = c(1, config$uninf_mean, 2), param = "mn", sigma = config$uninf_sigma)
      mcmc <- NULL
    }
  }
  

  #robustifiyng for easier output
  rob <- robby(mcmc_r = mcmc, map_r = map, config_r = config, cnfg_str_r = cnfg_str, data_r = data, cret_r = configar)
  results <- list(mcmc, map, rob)
  return(results)
  
}


# to do: work on change settings
# cbind(unquote(cnfg_str$n), unquote(cnfg_str$n)-unquote(cnfg_str$r)) ~ 1 | unquote(cnfg_str$group)