function Get-KEProfitTable {
    <#
.SYNOPSIS
    Generates a profit table for different price scenarios of a specified crypto on the Kraken exchange.

.PARAMETER Crypto
    The cryptocurrency symbol to calculate profit for. Defaults to "ETH".

.PARAMETER Currency
    The currency symbol to use for calculations. Defaults to "USD".

.PARAMETER Amount
    The amount of cryptocurrency to use for calculations. Defaults to 1.

.PARAMETER BuyFee
    The buying fee percentage to use for calculations. Defaults to 0.0026.

.PARAMETER SellFee
    The selling fee percentage to use for calculations. Defaults to 0.0026.

.PARAMETER BuyPrice
    The current buying price of the cryptocurrency. Defaults to the current market price of the specified cryptocurrency on Kraken.

.EXAMPLE
    PS C:\> Get-KrakenProfitTable -Crypto BTC -Currency USD -Amount 0.1 -BuyFee 0.001 -SellFee 0.001 -BuyPrice 50000

    PriceChange Price      Profit
    ----------- -----      ------
             -1 49500,00 -59,95
          -0,90 49550,00 -54,95
          -0,80 49600,00 -49,96
          -0,70 49650,00 -44,97
          -0,60 49700,00 -39,97
          -0,50 49750,00 -34,98
          -0,40 49800,00 -29,98
          -0,30 49850,00 -24,98
          -0,20 49900,00 -19,99
          -0,10 49950,00 -15,00
          -0,00 50000,00 -10,00
           0,10 50050,00  -5,00
           0,20 50100,00  -0,01
           0,30 50150,00   4,98
           0,40 50200,00   9,98
           0,50 50250,00  14,97
           0,60 50300,00  19,97
           0,70 50350,00  24,96
           0,80 50400,00  29,96
           0,90 50450,00  34,95
           1,00 50500,00  39,95
.NOTES
    The KrakenExchange PowerShell module is not affiliated with or endorsed by Kraken exchange.
    Author: wnapierala [@] hotmail.com, chatGPT
    Date: 03.2023
#>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [ValidatePattern("^[A-Za-z0-9]{1,10}(\.[A-Za-z0-9]{1,10})?$")]
        [string]$Crypto = "ETH",

        [Parameter(ValueFromPipeline = $true)]
        [ValidatePattern("^[A-Za-z0-9]{1,10}(\.[A-Za-z0-9]{1,10})?$")]
        [string]$Currency = "USD",

        [Parameter(ValueFromPipeline = $true)]
        [double]$Amount = 1,

        [Parameter()]
        [ValidateRange(0, [double]::MaxValue)]
        [double]$BuyPrice = (Invoke-RestMethod -Method GET -Uri "https://api.kraken.com/0/public/Ticker?pair=${Crypto}${Currency}").result."X${Crypto}Z${Currency}".'c'[0],

        [Parameter()]
        [ValidateRange(0, 0.0026)]
        [double]$BuyFee = 0.0026,
        
        [Parameter()]
        [ValidateRange(0, 0.0026)]
        [double]$SellFee = 0.0026,

        [double]$Step = 0.01
        )

    $Crypto = $Crypto.ToUpper()
    $Currency = $Currency.ToUpper()

    $outputCollection = @()
    # Here we assume that the current Crypto price
    [double]$current_crypto_price = $BuyPrice

    # Loop through different scenarios where the price of ETH changes by a percentage from -1% to 1%
    for ($p = -1; $p -le 1; $p += $Step) {
        $percentage = $p / 100.0
        $new_crypto_price = $current_crypto_price * (1 + $percentage)
        $profit = Find-KEProfit -crypto $Crypto -amount $Amount -buyfee $BuyFee -sellfee $SellFee -SellPrice $new_crypto_price -BuyPrice $current_crypto_price
        $output = [PSCustomObject]@{
            PriceChange = $p
            Price       = $new_crypto_price
            Profit      = $profit.profitNet
        }
        $outputCollection += $output
    }
    return $outputCollection
}
