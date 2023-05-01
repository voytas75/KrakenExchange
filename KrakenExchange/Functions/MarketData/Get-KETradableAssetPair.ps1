function Get-KETradableAssetPair {
    <#
    .SYNOPSIS
    Retrieves information about a specific Kraken asset pair or all tradable asset pairs.

    .DESCRIPTION
    The Get-KETradableAssetPair function retrieves information about a specific Kraken asset pair, such as trading fees, leverage, and margin. If the Pair parameter is not specified, information about all tradable asset pairs is returned.

    .PARAMETER Pair
    The trading pair to retrieve information for. If not specified, information about all tradable asset pairs is returned.

    .PARAMETER Info
    The type of information to retrieve for the asset pair. Possible values are "info" (default), "leverage", "fees", and "margin".

    .EXAMPLE
    PS C:\> Get-KETradableAssetPair -Pair "XXBTZUSD" -Info "fees"
    Retrieves trading fee information for the "XXBTZUSD" asset pair.

    .EXAMPLE
    PS C:\> Get-KETradableAssetPair
    Retrieves general information about all tradable asset pairs.

    .NOTES
    The KrakenExchange PowerShell module is not affiliated with or endorsed by Kraken exchange.
    Author: wnapierala [@] hotmail.com, chatGPT
    Date: 04.2023

    .LINK
    For more information, see the Kraken API documentation:
    https://docs.kraken.com/rest/#tag/Market-Data/operation/getTradableAssetPairs
    #>

    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidatePattern("^[A-Za-z0-9]{1,10}(\.[A-Za-z0-9]{1,10})?$")]
        [Alias("AssetPair", "AssetPairs", "Pairs")]
        [string]$Pair,

        [Parameter()]
        [validateSet("info", "leverage", "fees", "margin")]
        [string]$Info = "info"
    )
    
    $TradableAssetPairsMethod = "/0/public/AssetPairs"
    $endpoint = "https://api.kraken.com"
    $UserAgent = "Powershell Module KrakenExchange/1.0"
    $TradableAssetPairsUrl = $endpoint + $TradableAssetPairsMethod

    if ($Pair) {
        $TradableAssetPairsParams = [ordered]@{ 
            "pair" = $Pair
            "info" = $info
        }
    }
    else {
        $TradableAssetPairsParams = [ordered]@{ 
            "info" = $info
        }
    }

    $TradableAssetPairsHeaders = @{ 
        "User-Agent" = $UserAgent
    }

    $TradableAssetPairsResponse = Invoke-RestMethod -Uri $TradableAssetPairsUrl -Method Get -Headers $TradableAssetPairsHeaders -Body $TradableAssetPairsParams
    
    return $TradableAssetPairsResponse
}
