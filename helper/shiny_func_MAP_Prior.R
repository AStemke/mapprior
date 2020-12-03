
MAP.Prior.shiny <- function(data, config, cnfg_str, mcmc_cnfg = NULL, configar = NULL ){  

  # data is the dataset for the MAP prior is generated
  # config is the config data according to the dataset
  # cnfg_str has all the structure (string) config elements to the according dataset
  # configar is not used in this version, but might be included in the future
  # configar is the config data from which other data can borrow information,
  #         if nothing else is available (see retrieve.config),
  #          it has to be given again at serverside and sadly cannot be
  #          predefined as configurate$dat_1 in the function
  # mcmc provides the MCMC settings, the first one are the default settings, used either way by gMAP
  
  
  if(is.null(mcmc_cnfg)){
    # Standardoption by RBesT, global Options therefor need to be specified again, if changed
    .user_mc_options <- options(RBesT.MC.warmup = 2000, RBesT.MC.iter = 6000,
                                RBesT.MC.chains = 4, RBesT.MC.thin = 4, 
                                RBesT.MC.control =  list(adapt_delta=0.99, stepsize=0.01, max_treedepth=20)
    )
  }else{
    if(mcmc_cnfg$user_mcmc == TRUE){
      .user_mc_options <- options(RBesT.MC.warmup = mcmc_cnfg$warmup, RBesT.MC.iter = mcmc_cnfg$iter,
                                  RBesT.MC.chains = mcmc_cnfg$chains, RBesT.MC.thin = mcmc_cnfg$thin,
                                  RBesT.MC.control =  list(
                                    adapt_delta = mcmc_cnfg$delta, stepsize = mcmc_cnfg$stepsize, max_treedepth = mcmc_cnfg$treedepth)
      )
    }else{
      .user_mc_options <- options(RBesT.MC.warmup = 2000, RBesT.MC.iter = 6000,
                                  RBesT.MC.chains = 4, RBesT.MC.thin = 4, 
                                  RBesT.MC.control =  list(adapt_delta=0.99, stepsize=0.01, max_treedepth=20)
      )
    }
    if(mcmc_cnfg$reprod == TRUE){
      set.seed(mcmc_cnfg$seed)
    }
  }
  
  
  
  # Different cases for historic Data input exists or not
  
  if(cnfg_str$historic == TRUE){
    
    
    wip <- MAP.set.default(data = data, config = config, cnfg_str = cnfg_str)
    
    
    # Set the datasets to necessary names
    data <- as.data.frame(wip[[1]]) 
    
    #Default if no recommended configuration is provided
    config <- wip[[2]]
    
     if(cnfg_str$endpoint_type == "Binary"){

      mcmc <- gMAP(cbind(n, n-r) ~ 1 | study,
                   data = data,
                   family = binomial,
                   tau.dist = "HalfNormal",
                   tau.prior = config$tau,
                   beta.prior = config$sigma)
      
      map <- automixfit(mcmc, type = "beta", Nc = config$Nc_min:config$Nc_max)
      
     }
    
    #Normal Case ####
    if(cnfg_str$endpoint_type == "Normal"){
      
      # data$y.se <- config$sigma/sqrt(data$n)
      
      mcmc <- gMAP(cbind(y, y.se) ~ 1 | study, 
                   weights = data$weight,
                   data=data,
                   family = gaussian,
                   tau.dist ="HalfNormal",
                   tau.prior = cbind(0, config$tau),
                   beta.prior = cbind(0, config$sigma))
      map <- automixfit(mcmc, type = "norm", Nc = config$Nc_min:config$Nc_max)
      
    }
    
    # TTE Case ####
    if(cnfg_str$endpoint_type == "TTE"){
      
      
      mcmc <- gMAP(cbind(log.hr, log.hr.se) ~ 1 | study, 
                   weights = data$weight,
                   data=data,
                   family = gaussian,
                   tau.dist ="HalfNormal",
                   tau.prior = cbind(0, config$tau),
                   beta.prior = cbind(0, config$sigma))
      map <- automixfit(mcmc, type = "norm", Nc = config$Nc_min:config$Nc_max)
      
    }
  }else{
    
    wip <- MAP.set.default(data = NULL, config = config, cnfg_str = cnfg_str)
    
    #Default if no recommended configuration is provided
    config <- wip[[2]]
    
    if(cnfg_str$endpoint_type == "Binary"){
      config <- retrieve.config(config, "uninf_mean", stand = 0.5, cret = configar)
      map <- mixbeta(Uninf = c(1, config$uninf_mean, 2), param = "mn")
      mcmc <- NULL
    }
    if(cnfg_str$endpoint_type == "Normal"){
      config <- retrieve.config(config, "uninf_mean", stand = 1, cret = configar)
      map <- mixnorm(Uninf = c(1, config$uninf_mean, 2), param = "mn", sigma = config$uninf_sigma)
      mcmc <- NULL
    }
    if(cnfg_str$endpoint_type == "TTE"){
      config <- retrieve.config(config, c("rob_mean"), stand = 1, cret = configar)
      map <- mixnorm(Uninf = c(1, log(config$uninf_mean), 2), param = "mn", sigma = config$uninf_sigma)
      mcmc <- NULL
    }
  }
  

  #robustifiyng for easier output
  rob <- robby(mcmc_r = mcmc, map_r = map, config_r = config, cnfg_str_r = cnfg_str, data_r = data, cret_r = configar)
  gonogo <- gonogo_ui(rob = rob, cnfg_str = cnfg_str, round = TRUE)
  
  # Don't change the order of results 
  # 1.mcmc, 2.map, 3.rob, 4.config, 5.cnfg_str, 6.mcmc_cnfg, 7.configar, 8.gonogo
  results <- list(mcmc, map, rob, config, cnfg_str, mcmc_cnfg, configar, gonogo)
  return(results)
  
}
