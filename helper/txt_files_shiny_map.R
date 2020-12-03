# Texts



txt_main_page <- HTML(   "This Shiny App allows you to generate Meta Analytic Predictive (MAP) Priors from historical Data via a Bayesian hierarchical model." ,"<br>","<br>",
  
  "The app uses",
                         packageDescription("RBesT")$Package,
                         " Version ",
                         packageDescription("RBesT")$Version,
                         " to calculate the MAP Priors. For further information please refer to the",
                         packageDescription("RBesT")$Package,
                         " Documentation and Vignettes." ,"<br>","<br>", 
    
  "This App is not validated now and is in development. Please use it in fullscreen for better user experience." ,"<br>","<br>",
  
  "<Strong>", "If you would like to fit a new model, please refresh the page, so everything will be set back to default.","</strong>" ,"<br>","<br>",
  

  "First please choose your endpoint and the number of arms (1 or 2) you would like to evaluate." ,"<br>","<br>",
    
  "If you should encounter any unexpected Erros or may have questions or feedback, please do not hesitate to contact me:" ,"<br>","<br>",
    
  "alexander.stemke@boehringer-ingelheim.com" ,"<br>","<br>",
    
  "For testing reasons example datasets are provided in the file according to the app." ,"<br>","<br>",
    
  "Please refer to Neuenschwander et al. (2010) <doi:10.1177/1740774509356002> and Schmidli et al. (2014) <doi:10.1111/biom.12242> for details on the methodology." )


txt_upload_data <- HTML(
  "Upload up to two datasets or specify your flat prior. Your dataset should include those Variable, their names you have to enter accordingly.", "<br>",
   "So far only .csv and RData files are supported to upload. If you would like to be include other formats, feel free to mail me a request.", "<br>",

        "Binary", "<br>",
        "A dataset with 3 columns is expected. A label for each study, number of participants and number of responders.", "<br>", "<br>",
        
        "Normal", "<br>",
        "A dataset with 3 columns is expected. A label for each study, number of participants and the summary statistic y.", "<br>", "<br>",
        
        "TTE", "<br>",
        "A dataset with 4 columns is expected. A label for each study, your hazard ratio , the randomization ratio k:1 and the number of observed events.", "<br>", "<br>",
    )



txt_recommended_configurations <- HTML(
  "Those configurations are optional. Be aware that the amount of borrowing the historcial information is expressed by the ratio of tau/sigma.", "<br>",
  "tau represents the in between heterogeneity of your studies and sigma represents the sampling standard deviation. So, choose your tau according ", "<br>", "<br>",
  "to your data situation. Default is tau/sigma = 0.5", "<br>", "<br>",
             
  "A possible guideline:", "<br>",
  "<table>",
  "<tr>", "<th>", "Heterogeneity", "</th>", "<th>", "","</th>", "<th>", "tau/sigma", "</th>",  "</tr>",
  "<tr>", "<td>", "small" ,"</td>","<td>","","</td>","<td>", "0.0625", "</td>", "</tr>",
  "<tr>", "<td>", "substantial" ,"</td>","<td>","","</td>","<td>", "0.125", "</td>", "</tr>",
  "<tr>", "<td>", "large" ,"</td>","<td>","","</td>","<td>", "0.5", "</td>", "</tr>",
  "<tr>", "<td>", "very large" ,"</td>","","<td>","</td>","<td>", "1", "</td>", "</tr>",
  "</table>",  "<br>",
              
  "(see. Package 'RBesT', authors: Novartis Pharma AG [cph], Sebastian Weber [aut, cre], Beat Neuenschwander [ctb] et. al., https://cran.r-project.org/web/packages/RBesT/RBesT.pdf)", "<br>", "<br>",
              
  "Sigma and Tau Defaults", "<br>",
  "For binary endpoints sigma = 2,                  and tau = sigma/2 therefor tau = 1, choose a smaller tau if your confident that your exchangeability assumptions holds.", "<br>",
  "For normal endpoints sigma = 100*sd(data$y)      and tau = sigma/2.", "<br>",
  "For TTE    endpoints sigma = 10*sd(data$log.hr)  and tau = sigma/2.", "<br>", "<br>",
  
  "For Normal and TTE endpoints weights can be used for each study.", "<br>",
      "Normal  = n", "<br>",
      "TTE     = eventsobs",  "<br>", "<br>",
  
  
  "You are free to choose the number of mixture components for your prior distribution.", "<br>", 
  "Please be aware that a robustification will be added, you can delete it any time by setting Robust Factor = 0.", "<br>",
  "E.g. with robustification minimum = maximum = 3, your prior distribution will include 4 Mixture components.",  "<br>", "<br>",

  "If you use the default the mixture distribution with the best AIC between 1 and 5 components is provided.", "<br>", "<br>",
  
  "It is strongly recommendid to use the weights for fitting the model.",  "<br>"
  
    )


txt_output <- HTML(
      "After uploading your data or specifyng your prior and MCMC settings press 'Submit any changes' and please be patient while the", "<br>",
      "Bayesian hierarchical model will be fitted. Depending to your hardware and MCMC settings it can take a few seconds up to several minutes.", "<br>", "<br>",
      
      "The bolt black lines shows your prior and the dashed coloured lines the parts of it.",  "<br>",
      "You now can change the robustness to anything you desire.", "<br>", "<br>",
      
      "If you've uploaded historic data the Robustness mean is by default the MCMC mean.",  "<br>",
      "Default otherwise is 0.5 for binary and 0 for Normal and TTE endpoints.", "<br>", "<br>",
     
      "After changing robustness settings just press the button again,",  "<br>",
      "if you haven't changed anything you will get instantly your new model.",  "<br>", "<br>",
      
      "If you change different settings like the endpoint, dataset, tau, set.seed etc,",  "<br>",
      "you have to fit the model again.", "<br>"
      )

txt_help <- HTML(
           
            "The app uses "
            ,packageDescription("RBesT")$Package,
             " Version "
            ,packageDescription("RBesT")$Version,
            " to calculate the MAP Priors.",  "<br>", "<br>",
           
            "For further information please refer to the"
            ,packageDescription("RBesT")$Package,
            " Documentation and Vignettes.", "<br>", "<br>",
            
            
            "Authors: Alexander Stemke, Dr. Martin Oliver Sailer", "<br>", "<br>",
            
            "Contributors: Steven Brooks, Sahin Saide", "<br>", "<br>",
            
            "Maintainer: Alexander Stemke", "<br>", "<br>",
            
            "In case of issues or any feedback please contact:", "<br>",
            "alexander.stemke@boehringer-ingelheim.com", "<br>", "<br>",
            
            "This App was developed during my internship at Boehringer Ingelheim under the supervision of
            Dr. Martin Oliver Sailer.", "<br>", "<br>",
            
            "This is App Beta Version 00.02.03 by November 2020", "<br>"
                  
                  )

