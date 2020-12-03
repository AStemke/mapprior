# Helper for Configurations

#those two text functions are from Oliver Sailers GoNoGo App and are slightly modified
#betamix.text formats a univariate Beta mixture distribution from RBesT for Text output.####
betamix.text <- function(betamix){
  pcv <- round(as.vector(betamix),2)
  ncomp <- length(pcv)/3
  txt<-paste0("Your Prior is a ",attributes(betamix)$class[1]," = ")
  if(ncomp>1){
    for(i in 1:(ncomp-1)){
      txt <- paste0(txt,paste0( pcv[3*(i-1)+1],"*Beta(",pcv[3*(i-1)+2],",",pcv[3*(i-1)+3],") + " ))
    }
    txt <- paste0(txt, pcv[3*(ncomp-1)+1],"*Beta(",pcv[3*(ncomp-1)+2],",",pcv[3*(ncomp-1)+3],")")
  }else{
    txt <- paste0(txt, pcv[1],"*Beta(",pcv[2],",",pcv[3],")")
  }
  print(txt)
}

#normmix.text formats a univariate Beta mixture distribution from RBesT for Text output.####
normmix.text <- function(normmix){
  pcv <- round(as.vector(normmix),2)
  ncomp <- length(pcv)/3
  txt<-paste0("Your Prior is a ",attributes(normmix)$class[1]," = ")
  if(ncomp>1){
    for(i in 1:(ncomp-1)){
      txt <- paste0(txt,paste0( pcv[3*(i-1)+1],"*Norm(",pcv[3*(i-1)+2],",",pcv[3*(i-1)+3],") + " ))
    }
    txt <- paste0(txt, pcv[3*(ncomp-1)+1],"*Norm(",pcv[3*(ncomp-1)+2],",",pcv[3*(ncomp-1)+3],")")
  }else{
    txt <- paste0(txt, pcv[1],"*Norm(",pcv[2],",",pcv[3],")")
  }
  print(txt)
}

#chose one of the texts depending on class
dist.text <- function(mix){
  if(attributes(mix)$class[1] == "betaMix"){
    out <- as.character(betamix.text(mix))
  }
  if(attributes(mix)$class[1] == "normMix"){
    out <- as.character(normmix.text(mix))
  }
}


############

#retrieve configurate either entered or otherwise from the first dataset 

retrieve.config <- function(config, para, stand = NA, cret = NULL){
  
  for(i in 1:length(para)){
    # just do something if the value is missing
    if(is.na(config[,para[i]])){
      # look at the reference file cret for config retrieve, if it exsits
      if(!is.null(cret[,para[i]])){
        # if the value exists take it
        if(!is.na(cret[,para[i]])){
          config[,para[i]] <- cret[,para[i]]
        }else{
          #otherwise use the provided stand in parameter
          config[,para[i]] <- stand[i]
        }
      }else{
        config[,para[i]] <- stand[i]
      }
    }
  }
  config
}




# 
# rc <- function(config, para, stand = NA, cret = NULL){
#   
#   
#   for(i in 1:length(para)){
#     if(as.character(para[i]) %in% colnames(config)){
#       
#     }
#   }
#   
#   
#   
#   for(i in 1:length(para)){
#     # just do something if the value is missing
#     if(is.na(config[,para[i]])){
#       # look at the reference file cret for config retrieve, if it exsits
#       if(!is.null(cret[,para[i]])){
#         # if the value exists take it
#         if(!is.na(cret[,para[i]])){
#           config[,para[i]] <- cret[,para[i]]
#         }else{
#           #otherwise use the provided stand in parameter
#           config[,para[i]] <- stand[i]
#         }
#       }else{
#         config[,para[i]] <- stand[i]
#       }
#     }
#   }
#   config
# }




# unquote
unquote <- function(x){
  eval(parse(text = x))
}

# so that the values are numeric
Numeric.Config <- function(config){
  VarChar <- which(config == config$endpoint_type)
  config[,-VarChar] <- as.numeric(config[-VarChar])
  config
}



# Changes the names entered in Shiny, so it works everywhere the same
# Sets defaults for the data

MAP.set.default <- function(data, config, cnfg_str){

  if(cnfg_str$historic == TRUE){
    # Historical Data
    names(data)[which(names(data) == cnfg_str$study)]     <- "study"
    
    #Binary 
    if(cnfg_str$endpoint_type == "Binary"){
      
      names(data)[which(names(data) == cnfg_str$n)]         <- "n"
      names(data)[which(names(data) == cnfg_str$r)]         <- "r"
      
      if(is.na(config$tau)){
        config$tau <- 1
      }
      if(is.na(config$sigma)){
        config$sigma <- 2
      }
    }
    #Normal
    if(cnfg_str$endpoint_type == "Normal"){
      
      names(data)[which(names(data) == cnfg_str$n)]         <- "n"
      names(data)[which(names(data) == cnfg_str$y)]         <- "y"
      
      
      if(is.na(config$sigma)){
        config$sigma <- 100*sd(data$y)
      }
      if(is.na(config$tau)){
        config$tau <- config$sigma/2
      }
      
      data$y.se <- config$sigma/sqrt(data$n)
      
      if(cnfg_str$weight == TRUE){
        data$weight <- data$n
      }else{
        data$weight <- NULL
      }
    }
    #TTE
    if(cnfg_str$endpoint_type == "TTE"){
      names(data)[which(names(data) == cnfg_str$hr)]        <- "hr"
      names(data)[which(names(data) == cnfg_str$k)]         <- "k"
      names(data)[which(names(data) == cnfg_str$eventsobs)] <- "eventsobs"
      
      
      # transformation for log normal
      data$log.hr <- log(data$hr)
      
      
      #se formular equivalent to gonogo app
      data$log.hr.se <- sqrt((data$k+1)^2/(data$k*data$eventsobs))
      
      if(cnfg_str$weight == TRUE){
        data$weight <- data$eventsobs
      }else{
        data$weight <- NULL
      }
      
      
      if(is.na(config$sigma)){
        config$sigma <- 10*sd(data$log.hr)
      }
      
      if(is.na(config$tau)){
        config$tau <- config$sigma/2
      }
      
      if(!is.na(config$rob_mean)){
        config$log_rob_mean <- log(config$rob_mean)
      }
    }
  
  }else{
    # No historical data
    # Binary
    if(cnfg_str$endpoint_type == "Binary"){
      if(is.na(config$tau)){
        config$tau <- 1
      }
      if(is.na(config$sigma)){
        config$sigma <- 2
      }
    }
    # Normal
    if(cnfg_str$endpoint_type == "Normal"){
      if(is.na(config$sigma)) {
        config$sigma <- config$uninf_sigma
      }
      if(is.na(config$tau)){
        config$tau <- config$sigma/2
      }
    }
    #TTE
    if(cnfg_str$endpoint_type == "TTE"){
      if(is.na(config$sigma)) {
        if(is.na(config$uninf_sigma)){
          #derived for k = 1 and eventsobs = 1
          config$sigma <- 2
        }else{
          config$sigma <- config$uninf_sigma
        }
      }
      
      if(!is.na(config$rob_mean)){
        config$log_rob_mean <- log(config$rob_mean)
      }
    }
  }
  
  res <- list(data, config)
  return(res)
  
}



# Robustification

robby <- function(mcmc_r, map_r, config_r, cnfg_str_r, data_r = NULL, cret_r = NULL){ 

  
  #robby is the universal robustification method in the shiny_func_MAP_Prior and on the server side
  
  wip      <- MAP.set.default(data = data_r, config = config_r, cnfg_str = cnfg_str_r)
  data_r   <- as.data.frame(wip[[1]]) 
  config_r <- wip[[2]]
  
  #if a MCMC was running, that mean is used otherwise 0 or 0.5 as stand in parameter
  if(!is.null(mcmc_r)){
    stand_par <- summary(mcmc_r)[[3]][1]
  }else{
    if(cnfg_str_r$endpoint_type == "Binary"){
      stand_par <- 0.5
    }else{
      stand_par <- 0
    }
  }
  
  
  #if a parameter is manually entered use that otherwise use the stand in paramater
  #so the robust mean for the second dataset can be used if provided in the first dataset
  if(cnfg_str_r$endpoint_type == "Binary"){
    config_r <- retrieve.config(config_r, "rob_mean", stand = stand_par, cret = cret_r)
    rob <- robustify(map_r, weight = config_r$rob, mean = config_r$rob_mean)
  }
  
  if(cnfg_str_r$endpoint_type == "Normal"){
    config_r <- retrieve.config(config_r, c("rob_mean"), stand = stand_par, cret = cret_r)
    # config_r <- retrieve.config(config_r, c("uninf_sigma"), cret = cret_r)
    rob <- robustify(map_r, weight=config_r$rob, mean=config_r$rob_mean, sigma = config_r$sigma)
  }
  if(cnfg_str_r$endpoint_type == "TTE"){
    # config_r <- retrieve.config(config_r, c("uninf_sigma"), cret = cret_r)
    if(is.na(config_r$rob_mean)){
      config_r <- retrieve.config(config_r, c("rob_mean"), stand = stand_par, cret = cret_r)
      rob <- robustify(map_r, weight=config_r$rob, mean=config_r$rob_mean, sigma = config_r$sigma)
    }else{
      rob <- robustify(map_r, weight=config_r$rob, mean=config_r$log_rob_mean, sigma = config_r$sigma)
    }
    
  }
  
  return(rob)
  
}


# Generates Userfriendly Output so people can directly use the results for the GoNoGo App


gonogo_ui <- function(rob, cnfg_str, round = FALSE){
  if(cnfg_str$endpoint_type == "Binary"){
    n_subj <- colSums(rob[-1,])
    r_rate <- rob[2,]/n_subj
    weight <- rob[1,]
    
    GoNoGo <- cbind(r_rate, n_subj, weight)
    colnames(GoNoGo) <- c("Response Rate", "Number of subjects", "Weight")
    
    if(round == TRUE){
      GoNoGo[,-1] <- round(GoNoGo[,-1], 2)
      GoNoGo[,1]  <- round(GoNoGo[,1], 4)
    }
    
  }
  
  if(cnfg_str$endpoint_type == "Normal"){
    Mean     <- rob[2,]
    Variance <- rob[3,]*rob[3,]
    Weight   <- rob[1,]
    
    GoNoGo   <- cbind(Mean, Variance, Weight)
    
    if(round == TRUE){
      GoNoGo <- round(GoNoGo, 2)
    }
    
  }
  
  if(cnfg_str$endpoint_type == "TTE"){
    
    # set k = 1 because equation is over identificated
    k <- 1
    n_events <- ((k+1)^2)/(k*(rob[3,]^2))
    hr <- exp(rob[2,])
    weight <- rob[1,]
    
    GoNoGo <- cbind(hr, k, n_events, weight)
    colnames(GoNoGo) <- c("Hazard Ratio", "Randomization k:1", "Number of Events", "Weight")
     
    if(round == TRUE){
      GoNoGo[,-1] <- round(GoNoGo[,-1], 2)
      GoNoGo[,1]  <- round(GoNoGo[,1], 4)
    }
    
  }
  
  
  if(any(rownames(GoNoGo) == "robust")){
    if(GoNoGo["robust", "Weight"] == 0){
      ind_r <- which(rownames(GoNoGo) == "robust")
      GoNoGo <- GoNoGo[-ind_r,]
    }
  }
  
  if(!is.null(nrow(GoNoGo)))
  if(nrow(GoNoGo) > 4){
    GoNoGo <- "Your Prior has more then 4 components. Please set the Mixture components maximum (at Recommended confiuration) to 3 (4 iff Robustness Factor = 0) and fit the model again."
  }
  
  return(GoNoGo)
  
}
