# Texts
str(packageDescription("RBesT"))
packageDescription("RBesT")$Package
packageDescription("RBesT")$Version


txt_main_page <- paste(
  "This Shiny App allows you to generate Meta Analytic Predictive (MAP) Priors from historical Data.
     On this main page please choose your Endpoint. Available are Binary, Normal and Time To Event (TTE) Endpoints. \n
     The app uses",
  packageDescription("RBesT")$Package,
  " Version ",
  packageDescription("RBesT")$Version,
  " to calculate the MAP Priors. For fruther information please refer to the",
  packageDescription("RBesT")$Package,
  "Documentation.
    
    This App is not validated now and is in development. Please use it in Fullscreen for better user experience.\n

    First please choose your endpoint and the number of arms (1 or 2) you would like to evaluate.

    Secondly at the next tab 'Upload Data' Tab are mandatory inputs.
    You can upload your Data as CSV and my configurate the read in process, regarding to separation header etc.
    Please be sure that the columns in your data are named according the examples explained in that Tab.
    unfortunately, a dynamic input isn't implemented now.
    If you want to use historic Data it is recommended to use the first arm therefor, because the second data might use results
    from your regarding arm e.g.: Standard Deviation if it is missing etc.
    
    Afterwards you may be able to configurate key parameter at the 'Recommended Configuration' tab.
    Inputs at that tab are recommended but not necessary.
    This app provides reasonable default configurations.
    
    At the last tab 'Output' you have to submit your data and configurations.
    Next the gMAP function will be executed. If you've uploaded historic data a forest plot will be plotted,
    otherwise you receive a message that a forest plot is not applicable.
    After the plot or message has appeared please press the button to get your prior distribution.
    You will be able to adjust the robustification easily. Just change the settings and press the button again.
    
    If you wish to change any other configuration you have the run the MCMC sampling again.
    
    If you should encounter any Erros or may have questions, please do not hesitate to contact me:
    
    alexander.stemke@boehringer-ingelheim.com
    
    I kindly ask you to provide me your feedback and input for further development of the app.
    There are still a few features I am working on, but it would be great to know, what you need to change
    or features you would like to see included
    e.g. number of MCMC iterations, a recommendation for tau etc...
    With your feedback I can implement and prioritize those features during my internship.
    For testing reasons example datasets are provided in the file according to the app.
  ")



txt_upload_data <- paste(
  "Upload up to two datasets or specify your flat prior. Following the structure your dataset should have will be explained.
        You can find example datasets for each endpoint in your file regarding the app.

        Binary
        A dataset with 3 columns is expected. The grouping variable should be named 'study', the according number of participants 'n', and 'r' represents the number of responses.
        
        Normal
        A dataset with 3 columns is expected. The grouping variable should be named 'study', the according number of participants 'n', and 'y' the dependent variable.
        
        TTE
        A dataset with 4 columns is expected. The grouping variable should be named 'study', your hazard ratio 'hr', the randomization ratio k:1 'k' and the number of observed events 'eventsobs'.
    ")

txt_recommended_configurations <- paste(" 
  Those configurations are optional. Be aware that the amount of borrowing the historcial information is expressed by the ratio of tau/sigma.
  tau represents the in between heterogeneity of your studies and sigma represents the sampling standard deviation. So, choose your tau according 
  to your data situation. Default is tau/sigma = 0.5
             
             
             A possible guideline:
              Heterogeneity   tau/sigma
              small           0.0625
              substantial     0.125
              large           0.5
              very large      1  
              
  Sigma and Tau Defaults
  For binary endpoints sigma = 2, therefor tau = 1, choose a smaller tau if your confident that your exchangeability assumptions holds.
  For normal endpoints sigma = 100*sd(data$y)      and tau = sigma/2.
  For TTE    endpoints sigma = 100*sd(data$log.hr) and tau = sigma/2.
  
  
  You are free to choose the number of mixture components for your prior distribution. 
  Please be aware that a robustification will be added, you can delete it any time by setting Robust Factor = 0.
  E.g. with robustification minimum = maximum = 3, your prior distribution will include 4 Mixture components.

  If you use the default the Distribution with the best AIC between 1 and 5 components is provided.
  
      ")


txt_output <- paste("
      After uploading your data or specifyng your prior press 'Submit to calculate ... Prior' and please be patient, 
      the MCMC simulation will take a while, even the example datasets can take up to a few minutes depending on your hardware.
      When a forest plot or an according message is displayed click 'Press to plot and change robustness', 
      the prior mixture distribution an it's plot will be provided.
      The bolt black lines shows your prior and the dashed coloured lines the parts of it.
      You now can change the robustness to anything you desire.
      
      If you've uploaded historic data the Robustness mean is by default the MCMC mean.
      Default for otherwise is 0.5 for binary and 0 for Normal and TTE endpoints.
      After changing robustness settings just press the lower button again.
      If you change different settings like the endpoint, dataset, tau etc,
      you have to calculate the Prior again and wait for the new forest plot output.
      ")


