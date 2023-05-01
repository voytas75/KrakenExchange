function Find-KEProfit {
    <#
.SYNOPSIS
    Calculates the net profit from a trade on the Kraken cryptocurrency exchange.

.DESCRIPTION
    The Find-ProfitKraken function calculates the net profit from a trade on the Kraken cryptocurrency exchange. The function takes several parameters, such as the cryptocurrency to trade, the currency to trade against, the amount of the cryptocurrency to trade, the buy and sell fees, and the buy and sell prices. The function returns the net profit from the trade after fees are deducted.

.PARAMETER Crypto
    The cryptocurrency to trade. The default value is "ETH".

.PARAMETER Currency
    The currency to trade against. The default value is "USD".

.PARAMETER Amount
    The amount of the cryptocurrency to trade. The default value is 1.

.PARAMETER BuyFee
    The buy fee for the trade. The default value is 0.0026.

.PARAMETER SellFee
    The sell fee for the trade. The default value is 0.0026.

.PARAMETER SellPrice
    The sell price for the trade. This parameter is mandatory.

.PARAMETER BuyPrice
    The buy price for the trade. If not provided, the function will retrieve the current buy price from the Kraken API.

.EXAMPLE
    PS C:\> Find-ProfitKraken -Crypto "BTC" -Currency "USD" -Amount 2 -SellPrice 50000
    Returns the net profit from selling 2 BTC for $50,000 on Kraken after fees are deducted.

.NOTES
    The KrakenExchange PowerShell module is not affiliated with or endorsed by Kraken exchange.
    Author: wnapierala [@] hotmail.com, chatGPT
    Date: 03.2023
#>

    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("^[A-Za-z0-9]{1,10}(\.[A-Za-z0-9]{1,10})?$")]
        [string]$Crypto = "XBT",

        [Parameter()]
        [ValidatePattern("^[A-Za-z0-9]{1,10}(\.[A-Za-z0-9]{1,10})?$")]
        [string]$Currency = "USD",

        [Parameter()]
        [ValidateRange(0, [double]::MaxValue)]
        [double]$Amount = 1,

        [Parameter()]
        [ValidateRange(0, 0.0026)]
        [double]$BuyFee = 0.0026,

        [Parameter()]
        [ValidateRange(0, 0.0026)]
        [double]$SellFee = 0.0026,

        [Parameter(Mandatory = $true)]
        [double]$SellPrice,

        [Parameter()]
        [ValidateRange(0, [double]::MaxValue)]
        [double]$BuyPrice = (Invoke-RestMethod -Method GET -Uri "https://api.kraken.com/0/public/Ticker?pair=${Crypto}${Currency}").result."X${Crypto}Z${Currency}".'c'[0]
    )

    $Crypto = $Crypto.ToUpper()
    $Currency = $Currency.ToUpper()

    # Get buy price
    $current_eth_price = $BuyPrice 
    #Write-Debug $current_eth_price
    # Calculate the profit based on the provided parameters
    $buy_cost = $Amount * $current_eth_price
    $buy_cost_fee = $buy_cost * $BuyFee
    #Write-Debug $buy_cost_fee
    $sell_cost = $Amount * $SellPrice
    $sell_cost_fee = $sell_cost * $SellFee
    #Write-Debug $sell_cost_fee
    $profitGross = $sell_cost - $buy_cost
    $costs = $buy_cost_fee + $sell_cost_fee
    $profitNet = $profitGross - $costs
    Write-Debug "Crypto: ${Crypto}, Currency: ${Currency}, Buy price: ${buyPrice}, Sell price: ${SellPrice}, Buy fee: ${BuyFee}, Sell fee: ${SellFee}"
    $KEProfit_object = [PSCustomObject]@{
        "Crypto"       = ${Crypto}
        "Currency"     = ${Currency}
        "Buy price"    = ${buyPrice}
        "Sell price"   = ${SellPrice}
        "Amount"       = ${Amount}
        "Buy fee (%)"  = ${BuyFee}
        "Buy fee"      = ${buy_cost_fee}
        "Sell fee (%)" = ${SellFee}
        "Sell fee"     = ${sell_cost_fee}
        "profitGross"  = ${profitGross}
        "profitNet"    = ${profitNet}
    }
    return $KEProfit_object
}
