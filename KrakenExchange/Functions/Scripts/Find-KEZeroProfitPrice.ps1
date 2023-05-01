function Find-KEZeroProfitPrice {
<#
.SYNOPSIS
    Finds the zero-profit sell price for a given cryptocurrency on Kraken exchange.

.DESCRIPTION
    The Find-ZeroProfitPriceKraken function calculates and returns the zero-profit sell price for a given cryptocurrency on the Kraken exchange. It uses the Find-ProfitKraken function to calculate the profit at each sell price, and increases the sell price in a given step range until it reaches the zero-profit sell price.

.PARAMETER Crypto
    Specifies the cryptocurrency to find the zero-profit sell price for. Default is ETH.

.PARAMETER Currency
    Specifies the currency to find the zero-profit sell price in. Default is USD.

.PARAMETER Amount
    Specifies the amount of cryptocurrency to find the zero-profit sell price for. Default is 1.

.PARAMETER BuyFee
    Specifies the buy fee for the cryptocurrency. Default is 0.0026.

.PARAMETER SellFee
    Specifies the sell fee for the cryptocurrency. Default is 0.0026.

.PARAMETER StepRange
    Specifies the step range to increase the sell price by for each iteration. Default is 0.001.

.PARAMETER CurrentCryptPrice
    Specifies the current price of the cryptocurrency. If not specified, the function will get the current price from the Kraken API.

.EXAMPLE
    Find-ZeroProfitPriceKraken -Crypto ETH -Currency USD -Amount 2 -BuyFee 0.0026 -SellFee 0.0026 -StepRange 0.001 -Verbose
    Calculates the zero-profit sell price for 2 ETH in USD with 0.26% buy and sell fees, increasing the sell price by 0.1% for each iteration, and displays verbose output.

.INPUTS
    None.

.OUTPUTS
    Returns the zero-profit sell price for the specified cryptocurrency and currency.

.NOTES
    The KrakenExchange PowerShell module is not affiliated with or endorsed by Kraken exchange.
    Author: wnapierala [@] hotmail.com, chatGPT
    Date: 03.2023
#>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [ValidatePattern("^[A-Za-z0-9]{1,10}(\.[A-Za-z0-9]{1,10})?$")]
        [string]$Crypto = "ETH",

        [Parameter(ValueFromPipeline = $true)]
        [ValidatePattern("^[A-Za-z0-9]{1,10}(\.[A-Za-z0-9]{1,10})?$")]
        [string]$Currency = "USD",

        [Parameter(Mandatory = $false)]
        [ValidateRange(0, [double]::MaxValue)]
        [double]$Amount = 1,

        [Parameter()]
        [ValidateRange(0, 0.0026)]
        [double]$BuyFee = 0.0026,

        [Parameter()]
        [ValidateRange(0, 0.0026)]
        [double]$SellFee = 0.0026,

        [Parameter()]
        [ValidateRange(0, [double]::MaxValue)]
        [double]$StepRange = 0.001,

        [Parameter()]
        [Alias("BuyPrice", "Price")]
        [ValidateRange(0, [double]::MaxValue)]
        [double]$CurrentCryptPrice = (Invoke-RestMethod -Method GET -Uri "https://api.kraken.com/0/public/Ticker?pair=${Crypto}${Currency}").result."X${Crypto}Z${Currency}".'c'[0]
    )

    if (-not(Test-Connection api.kraken.com -Count 1 -ErrorAction SilentlyContinue)) {
        Write-Error "Unable to connect to api.kraken.com. Please check your internet connection and try again."
        return
    }

<#     if (-not(Get-Command Find-ProfitKraken -ErrorAction SilentlyContinue)) {
        # Import Find-ProfitKraken function
        . $PSScriptRoot\Find-ProfitKraken.ps1
    }
#>

$Crypto = $Crypto.ToUpper()
    $Currency = $Currency.ToUpper()

    $newSellPrice = $CurrentCryptPrice
    
    # Loop until zero-profit price is found
    while ($true) {
        # Calculate profit and target profit
        $profit = Find-KEProfit -Crypto $Crypto -Amount $Amount -BuyFee $BuyFee -SellFee $SellFee -SellPrice $newSellPrice -buyprice $CurrentCryptPrice
        # Check if accuracy condition is met
        if ($profit.profitNet -gt 0) {
            Write-Verbose "Crypto: ${crypto}, buy price: ${CurrentCryptPrice} USD, zero profit price: $($newSellPrice.ToString('N2')) USD, profit: $($profit.profitNet)"
            return $newSellPrice
        }

        # Update price range
        $newSellPrice += $StepRange
    }
}
