ui_mcmc <- tabItem(tabName = "mcmc",
                   h2("MCMC Settings"),
                   fluidPage(fluidRow(column(6,
                                             box(
                                               fluidPage(
                                                 numericInput("seed_1", "Random Seed", sample(.Random.seed, 1)),
                                                 checkboxInput("reprod_1", "Use above Seed", FALSE),
                                                 tags$hr(),
                                                 numericInput("warmup_1", "Warmup Iterations", 2000, min = 200, step = 200),
                                                 numericInput("iter_1", "Total Iterations", 6000, min = 600, step = 200),
                                                 numericInput("chains_1", "Chains", 4, min = 1),
                                                 numericInput("thin_1", "Thinning", 4, min = 1),
                                                 numericInput("delta_1", "Target acceptance rate delta", 0.99, step = 0.01),
                                                 numericInput("stepsize_1", "Stepsize", 0.01, step = 0.01),
                                                 numericInput("treedepth_1", "Maximum treedepth", 20, min = 5),
                                                 tags$hr(),
                                                 checkboxInput("user_mcmc_1", "Confirm to use personalized MCMC settings.", FALSE)
                                               )
                                             )),
                                      column(6,
                                             conditionalPanel(
                                               condition = "input.n_arms >=  2",
                                               box(
                                                 fluidPage(
                                                   numericInput("seed_2", "Random Seed", sample(.Random.seed, 1)),
                                                   checkboxInput("reprod_2", "Use Seed", FALSE),
                                                   tags$hr(),
                                                   numericInput("warmup_2", "Warmup Iterations", 2000, min = 200, step = 200),
                                                   numericInput("iter_2", "Total Iterations", 6000, min = 600, step = 200),
                                                   numericInput("chains_2", "Chains", 4, min = 1),
                                                   numericInput("thin_2", "Thinning", 4, min = 1),
                                                   numericInput("delta_2", "Target acceptance rate delta", 0.99, step = 0.01),
                                                   numericInput("stepsize_2", "Stepsize", 0.01, step = 0.01),
                                                   numericInput("treedepth_2", "Maximum treedepth", 20, min = 5),
                                                   tags$hr(),
                                                   checkboxInput("user_mcmc_2", "Confirm to use personalized MCMC settings.", FALSE)
                                                 )
                                               )
                                             )
                                             )
                                      )
                             )
                   )
