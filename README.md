# Cryptocurrencies - Value at Risk

## Timeline

### Step 1: Data preparation
* Loading of the active cryptocurrencies via `crypto2` library
* Arrange downloaded data frame by rank
* Use the first five rows and bind them into a data frame
* Leveraging the previous data frame, download the prices for the top-5 cryptocurrencies for specified dates again via `crypto2` library
* Create 5 data frames for each cryptocurrency by filtering the downloaded data by each cryptocurrency name
* Calculate the log-return
* Bind all prices into a data frame
* Bind all log returns to a data frame omitting all NA values
* Transform log-returns data frame to an xts object

### Step 2: Portfolio optimisation
* Initialise portfolio optimisation (add specifications, constraints and objectives)
* Find optimal weights for the training period, using the ROI method
* Backtest portfolio optimal weights using daily rebalancing
* Calculate portfolio returns using optimal weights
* Save .RDS file with prices and log-returns

### Step 3: Data Analysis and VaR Calculation
* Perform JB normality test for portfolio returns
* Perform ARCH Test for conditional heteroscedasticity of portfolio returns
* Perform ADF Test for stationarity of portfolio returns
* Estimate ARIMA model
* Value at Risk - GARCH Model fit
* Value at Risk - GARCH Model Backtesting
* Check residuals for autocorrelation
