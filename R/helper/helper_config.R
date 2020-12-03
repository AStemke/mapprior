# Helper for Configurations

#betamix.text formats a univariate Beta mixture distribution from RBesT for Text output.####
betamix.text <- function(betamix){
  pcv <- round(as.vector(betamix),3)
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
  pcv <- round(as.vector(normmix),3)
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
    out <- betamix.text(mix)
  }
  if(attributes(mix)$class[1] == "normMix"){
    out <- normmix.text(mix)
  }
}


############

#retrieve configurate either entered or otherwise from the first dataset 

retrieve.config <- function(config, para, stand = NA, cret = configurate$dat_1){
  
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




# unquote
unquote <- function(x){
  eval(parse(text = x))
}

# so that the values are numeric
Numeric.Config <- function(config){
  VarChar <- which(config == config$data_structure)
  config[,-VarChar] <- as.numeric(config[-VarChar])
  config
}


# Robustification



robby <- function(mcmc_r, map_r, config_r, cnfg_str_r, data_r, cret_r = configurate$dat_1){ 

  #robby is the universal robustification method in the shiny_func_MAP_Prior and on the server side
  
  #handle cases if nothing was entered for several cases.
  #equivalent to methods in shiny_func_MAP_Prior, sadly not safed
  if(cnfg_str_r$data_structure == "Binary"){
    if(is.na(config_r$tau)){
      config_r$tau <- 1
    }
    if(is.na(config_r$sigma)){
      config_r$sigma <- 2
    }
  }

  #hi

  if(cnfg_str_r$data_structure == "Normal"){
    if(cnfg_str_r$historic == TRUE){
      if(is.na(config_r$sigma)){
          config_r$sigma <- 100*sd(data_r$y)
      }
      if(is.na(config_r$tau)){
        config_r$tau <- config_r$sigma/2
      }
      data_r$y.se <- config_r$sigma/sqrt(data_r$n)
    }else{
      if(is.na(config_r$sigma)) {
        config_r$sigma <- config_r$uninf_sigma
      }
      
    }

  }
  
  if(cnfg_str_r$data_structure == "TTE"){
    print("TTE def")
    if(cnfg_str_r$historic == TRUE){
      data_r$log.hr <- log(data_r$hr)
      if(is.na(config_r$sigma)){
        config_r$sigma <- 100*sd(data_r$log.hr)
      }
      if(is.na(config_r$tau)){
        config_r$tau <- config_r$sigma/2
      }
    }else{
      if(is.na(config_r$sigma)) {
        config_r$sigma <- config_r$uninf_sigma
      }
    }
  }
  
  #if a MCMC was running, that mean is used otherwise 0 or 0.5 as stand in parameter
  if(!is.null(mcmc_r)){
    stand_par <- summary(mcmc_r)[[3]][1]
  }else{
    if(cnfg_str_r$data_structure == "Binary"){
      stand_par <- 0.5
    }else{
      stand_par <- 0
    }
  }
  
  #if a parameter is manually entered use that otherwise use the stand in paramater
  #so the robust mean for the second dataset can be used if provided in the forst dataset
  if(cnfg_str_r$data_structure == "Binary"){
    config_r <- retrieve.config(config_r, "rob_mean", stand = stand_par, cret = cret_r)
    rob <- robustify(map_r, weight = config_r$rob, mean = config_r$rob_mean)
  }
  if(cnfg_str_r$data_structure == "Normal"){
    config_r <- retrieve.config(config_r, c("rob_mean"), stand = stand_par, cret = cret_r)
    config_r <- retrieve.config(config_r, c("uninf_sigma"), cret = cret_r)
    rob <- robustify(map_r, weight=config_r$rob, mean=config_r$rob_mean, sigma = config_r$sigma)
  }
  if(cnfg_str_r$data_structure == "TTE"){
    print("TTE rob")
    config_r <- retrieve.config(config_r, c("rob_mean"), stand = stand_par, cret = cret_r)
    config_r <- retrieve.config(config_r, c("uninf_sigma"), cret = cret_r)
    rob <- robustify(map_r, weight=config_r$rob, mean=config_r$rob_mean, sigma = config_r$sigma)
  }
  
  return(rob)
  
  }

