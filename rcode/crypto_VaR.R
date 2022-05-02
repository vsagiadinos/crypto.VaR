#Clear environment
rm(list=ls())

#Load log-returns Data
crypto.returns <- readRDS("data/crypto.returns.rds")

#Perform JB normality test for portfolio returns
tseries::jarque.bera.test(crypto.returns$Portfolio)

#Perform ARCH Test for conditional heteroscedasticity
FinTS::ArchTest(crypto.returns$Portfolio, lags = 1)
FinTS::ArchTest(crypto.returns$Portfolio, lags = 5)
FinTS::ArchTest(crypto.returns$Portfolio, lags = 12)

#Perform ADF Test for stationarity
tseries::adf.test(crypto.returns$Portfolio)

#Perform autocorrelation tests
Box.test (crypto.returns$Portfolio, lag = 12, type = "Ljung-Box")
Box.test (crypto.returns$Portfolio ^ 2, lag = 12, type = "Ljung-Box")

#Estimating ARIMA model
forecast::auto.arima(crypto.returns$Portfolio, trace = T, 
                     test = "kpss", ic = c("bic"))

#Initializing GARGH Model
model_spec <- rugarch::ugarchspec(variance.model = list(model = "sGARCH",
                                                        garchOrder = c(1,1)),
                                  mean.model = list(armaOrder = c(1,0)),
                                  distribution.model = "std")
#GARCH Model fit
model_fit <- rugarch::ugarchfit(spec = model_spec, 
                                 data = crypto.returns$Portfolio,
                                 out.sample = nrow(filter(crypto.returns,
                                                          date >= (crypto.returns$date[1] + lubridate::years(2)))))
#GARCH Model Backtesting
model_roll <- rugarch::ugarchroll(spec = model_spec, data = crypto.returns$Portfolio,
                                  n.ahead = 1,
                                  n.start = nrow(filter(crypto.returns,
                                                        date <= (crypto.returns$date[1] + lubridate::years(2)))), 
                                  refit.every = 30,
                                  refit.window = "recursive"
)
rugarch::report(model_roll, type = "VaR", VaR.alpha = 0.01, conf.level = 0.99)
rugarch::report(model_roll, type = "VaR", VaR.alpha = 0.01, conf.level = 0.975)
rugarch::report(model_roll, type = "VaR", VaR.alpha = 0.01, conf.level = 0.95)

#Check residuals for autocorrelation
standadized_residuals <- model_fit@fit$residuals / model_fit@fit$sigma
Box.test (standadized_residuals, lag = 12, type = "Ljung-Box")
Box.test (standadized_residuals ^ 2, lag = 12, type = "Ljung-Box")