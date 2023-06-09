function Get-KETickerInformation {
<#
.SYNOPSIS
Retrieves ticker information for a given trading pair using the KrakenExchange API.

.DESCRIPTION
The Get-KETickerInformation function retrieves ticker information for a given trading pair using the KrakenExchange API.
For more information, see the Kraken API documentation: https://docs.kraken.com/rest/#tag/Market-Data/operation/getTickerInformation

.PARAMETER Pair
The trading pair to retrieve ticker information for, in the format "XBTUSD" (for Bitcoin to US dollar).

.EXAMPLE
PS C:> Get-KETickerInformation -Pair "XBTUSD"

Returns ticker information for the XBT/USD trading pair.

.NOTES
The KrakenExchange PowerShell module is not affiliated with or endorsed by Kraken exchange.
Author: chatGPT, wnapierala [@] hotmail.com
Date: 04.2023

.INPUTS
None, This function does not accept input by pipeline.

.OUTPUTS
The function returns an object that contains the ticker information for the given trading pair. The object includes information such as the last traded price, the bid and ask prices, and the volume of trades for the pair.

.EXAMPLE
PS C:> Get-KETickerInformation -Pair "XBTEUR"

This example retrieves ticker information for the XBTEUR trading pair.

#>[CmdletBinding()]
    param (
        [Parameter()]
        [ValidatePattern("^[A-Za-z0-9]{1,10}(\.[A-Za-z0-9]{1,10})?$")]
        [string]$Pair = "XBTUSD"
    )
    
    $TickerInformationMethod = "/0/public/Ticker"
    $endpoint = "https://api.kraken.com"
    $UserAgent = "Powershell Module KrakenExchange/1.0"
    $TickerInformationUrl = $endpoint + $TickerInformationMethod

    $TickerInformationParams = [ordered]@{ 
        "pair" = $Pair
    }
    
    $TickerInformationHeaders = @{ 
        "User-Agent" = $UserAgent
    }

    try {
        $TickerInformationResponse = Invoke-RestMethod -Uri $TickerInformationUrl -Method Get -Headers $TickerInformationHeaders -Body $TickerInformationParams
    }
    catch {
        Write-Error $_.Exception.Message
        return
    }
    
    return $TickerInformationResponse
}
