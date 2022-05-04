# Cryptocurrencies - Value at Risk

## Timeline

### Step 1: Data preparation
* Loading of the active cryptocurrencies via `crypto2` library
* Arrange downloaded dataframe by rank
* Use the first five rows and rbind them into a dataframe
* Leveraging the previous dataframe, download the prices for the top-5 cryptocurrencies for the specified dates
* Create 5 dataframes for each cryptocurrency by filtering the downloaded data by each cryptocurrency name and calculate the log-return
* Bind all prices into a dataframe
* Bind all log-returns to a dataframe omitting all NA values
* Transform log-returns dataframe to an xts object

### Step 2: Portfolio optimisation
* Initialise portfolio optimisation (add specifications, constraints and objective)
* Find optimal weights for training period, using ROI method
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
