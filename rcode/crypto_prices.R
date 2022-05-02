#Clear environment
rm(list=ls())

#Load required libraries
library(dplyr)
library(crypto2)
library(quantmod)
library(PortfolioAnalytics)

#Find top-5 active cryptocurrencies
symbols <- crypto_list(only_active = TRUE) %>%
            arrange(rank) %>%
            head(5)
View(symbols)

#Download daily data for top-5 active cryptocurrencies for past 3 years  
prices <- crypto_history(symbols, convert = "EUR",
                         start_date = Sys.Date() - lubridate::years(3))

#Calculate daily log-return for each symbol
crypto.1 <- prices %>% 
              filter(name == symbols$name[1]) %>% 
              mutate(log.return = Delt(close), type = "log")

crypto.2 <- prices %>% 
              filter(name == symbols$name[2]) %>% 
              mutate(log.return = Delt(close), type = "log")

crypto.3 <- prices %>% 
              filter(name == symbols$name[3]) %>%
              mutate(log.return = Delt(close), type = "log")

crypto.4 <- prices %>% 
              filter(name == symbols$name[4]) %>% 
              mutate(log.return = Delt(close), type = "log")

crypto.5 <- prices %>% 
              filter(name == symbols$name[5]) %>% 
              mutate(log.return = Delt(close), type = "log")

#Bind all prices into a single data frame
crypto.prices <- data.frame(as.Date(crypto.1$timestamp),
                            crypto.1$close, 
                            crypto.2$close, 
                            crypto.3$close, 
                            crypto.4$close,
                            crypto.5$close)

#Rename columns with symbol names
colnames(crypto.prices) <- c("date",
                             unique(crypto.1$name), 
                             unique(crypto.2$name),
                             unique(crypto.3$name),
                             unique(crypto.4$name),
                             unique(crypto.5$name))

#Bind all log-returns into a single data frame
crypto.returns <- data.frame(as.Date(crypto.1$timestamp),
                             crypto.1$log.return, 
                             crypto.2$log.return,
                             crypto.3$log.return,
                             crypto.4$log.return,
                             crypto.5$log.return)

#Rename columns with symbol names and remove missing values
colnames(crypto.returns) <- c("date",
                              unique(crypto.1$name), 
                              unique(crypto.2$name),
                              unique(crypto.3$name),
                              unique(crypto.4$name),
                              unique(crypto.5$name))
crypto.returns <- na.omit(crypto.returns)

#Transform log-returns data frame to xts object
crypto.returns.xts <- xts::as.xts(crypto.returns[2:6], 
                                  order.by = as.Date(crypto.returns$date))

#Initialize portfolio weights optimization
portfolio <- portfolio.spec(assets = colnames(crypto.returns.xts))

#Adding constraint for full investment
portfolio <- add.constraint(portfolio = portfolio,
                            type = "full_investment")

#Adding constraint for positive weights
portfolio <- add.constraint(portfolio = portfolio,
                            type = "box", min = 0.00 , max = 1)

#Adding minimize portfolio risk objective
portfolio <- add.objective(portfolio = portfolio,
                           type = "risk",
                           name = "var")

#Adding maximize portfolio return objective
portfolio <- add.objective(portfolio = portfolio,
                           type = "return",
                           name = "mean")

#Optimize portfolio based on constraints and objectives using ROI method
global_portfolio <- optimize.portfolio(R = crypto.returns.xts,
                      portfolio = portfolio, optimize_method = "quadprog",
                      trace = TRUE)

#Calculate portfolio returns
crypto.returns$portfolio <- crypto.returns[,2] * global_portfolio$weights[1]+
                            crypto.returns[,3] * global_portfolio$weights[2]+
                            crypto.returns[,4] * global_portfolio$weights[3]+
                            crypto.returns[,5] * global_portfolio$weights[4]+
                            crypto.returns[,6] * global_portfolio$weights[5]
#Remove unused variables
rm(prices, crypto.1, crypto.2, crypto.3, crypto.4, crypto.5, 
   crypto.returns.xts, portfolio, global_portfolio, symbols)

#Save data to .rds file
saveRDS(crypto.prices, file = "data/crypto.prices.rds")
saveRDS(crypto.returns, file = "data/crypto.returns.rds")