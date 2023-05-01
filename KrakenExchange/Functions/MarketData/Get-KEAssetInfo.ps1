function Get-KEAssetInfo {
    <#
    .SYNOPSIS
    Retrieves information about a specific asset or all tradable assets from the Kraken API.
        
    .DESCRIPTION
    This function retrieves information about a specific asset (e.g. currency) from the Kraken API. It requires the asset symbol as input, and returns detailed information about the asset including its name, ticker, trading volume, etc. If the `Asset` parameter is empty, information about all tradable assets will be retrieved.
        
    .PARAMETER Asset
    The symbol of the asset for which information is to be retrieved. If this parameter is empty, information about all tradable assets will be retrieved.
        
    .EXAMPLE
    Get-KEAssetInfo -Asset "XBT"
    Retrieves information about the "XBT" asset (Bitcoin) from the Kraken API.

    .EXAMPLE
    Get-KEAssetInfo
    Retrieves information about all tradable assets from the Kraken API.
        
    .LINK
    For more information, see the Kraken API documentation:
    https://docs.kraken.com/rest/#tag/Market-Data/operation/getAssetInfo

    .NOTES
    The KrakenExchange PowerShell module is not affiliated with or endorsed by Kraken exchange.
    Author: wnapierala [@] hotmail.com, chatGPT
    Date: 04.2023
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [ValidatePattern("^[A-Za-z0-9]{1,10}(\.[A-Za-z0-9]{1,10})?$")]
        [Alias("Assets")]
        [string]$Asset
    )
    
    $AssetInfoMethod = "/0/public/Assets"
    $endpoint = "https://api.kraken.com"
    $UserAgent = "Powershell Module KrakenExchange/1.0"
    $AssetInfoUrl = $endpoint + $AssetInfoMethod

    if ($Asset) {
        $AssetInfoParams = [ordered]@{ 
            "asset"  = $Asset
            "aclass" = "currency" 
        }
    }
    else {
        $AssetInfoParams = [ordered]@{ 
            "aclass" = "currency" 
        }
   
    }
    $AssetInfoHeaders = @{ 
        "User-Agent" = $UserAgent
    }

    $AssetInfoResponse = Invoke-RestMethod -Uri $AssetInfoUrl -Method Get -Headers $AssetInfoHeaders -Body $AssetInfoParams
        
    return $AssetInfoResponse
}    
        
 