function Get-KETradeVolume {
    <#
    .SYNOPSIS
    Retrieves trade volume data for a specific currency pair from the Kraken Exchange API.

    .DESCRIPTION
    The Get-KETradeVolume function retrieves trade volume data for a specific currency pair from the Kraken Exchange API. 
    It requires an API key and API secret, which can be either passed as parameters or retrieved from environment variables. 
    If the API secret is not provided, it will attempt to retrieve it by calling the Connect-KExchange function.

    .PARAMETER ApiKey
    The API key for the Kraken Exchange API. If not provided, it will attempt to retrieve it from the 'KE_API_KEY' environment variable.

    .PARAMETER ApiSecret
    The encoded API secret for the Kraken Exchange API. If not provided, it will attempt to retrieve it by calling the Connect-KExchange function.

    .PARAMETER Pair
    The currency pair for which to retrieve trade volume data. Must be in the format "XXXXXX". Defaults to "XBTUSD".

    .EXAMPLE
    PS C:\> Get-KETradeVolume -ApiKey "myApiKey" -ApiSecret "encoded_myApiSecret" -Pair "ETHUSD"
    Retrieves trade volume data for the ETH/USD currency pair using the specified API key and API secret.

    .LINK
    For more information, see the Kraken API documentation:
    https://docs.kraken.com/rest/#tag/User-Data/operation/getTradeVolume    

    .NOTES
    The KrakenExchange PowerShell module is not affiliated with or endorsed by Kraken exchange.
    Author: wnapierala [@] hotmail.com, chatGPT
    Date: 04.2023
    #>    
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidatePattern("[A-Z]")]
        [string]$Pair = "XBTUSD",

        [Parameter(Mandatory = $false)]
        [string]$ApiKey = ([Environment]::GetEnvironmentVariable('KE_API_KEY', 'user')),

        [Parameter(Mandatory = $false)]
        [Alias("encodedAPISecret")]
        [string]$ApiSecret = ([Environment]::GetEnvironmentVariable('KE_API_SECRET', 'user'))
    )

    # Check if ApiSecret is provided or needs to be retrieved
    if (-not $ApiSecret) {
        Disconnect-KExchange
        Connect-KExchange
        $ApiKey = ([Environment]::GetEnvironmentVariable('KE_API_KEY', "User"))
        $ApiSecretEncoded = $ApiSecret = ([Environment]::GetEnvironmentVariable('KE_API_SECRET', "User"))
    }
    else {
        $ApiSecretEncoded = $ApiSecret
    }

    # Define User-Agent header
    $UserAgent = "Powershell Module KrakenExchange/1.0"

    # Define API endpoint and version
    $endpoint = "https://api.kraken.com"
    $TradeVolumeMethod = "/0/private/TradeVolume"
    $TradeVolumeUrl = $endpoint + $TradeVolumeMethod

    # Generate nonce for API request
    $nonce = [Math]::Round((New-TimeSpan -Start "1/1/1970").TotalMilliseconds)

    # Define parameters for API request
    $TradeVolumeParam = [ordered]@{
        "nonce" = $nonce
        "pair"  = $Pair
    }

    # Generate signature for API request
    $signature = Set-KESignature -Payload $TradeVolumeParam -URI $TradeVolumeMethod -ApiSecret $ApiSecretEncoded

    # Define headers for API request
    $TradeVolumeHeaders = @{ 
        "API-Key"    = $apiKey; 
        "API-Sign"   = $signature; 
        "User-Agent" = $useragent
    }

    # Send API request and retrieve response
    $TradeVolumeResponse = Invoke-RestMethod -Uri $TradeVolumeUrl -Method Post -body $TradeVolumeParam -Headers $TradeVolumeHeaders
    
    if ($TradeVolumeResponse.error -contains "EAPI:Invalid key") {
        [Environment]::SetEnvironmentVariable("KE_API_KEY", "", "User")
        Connect-KExchange
    }

    # Return the response
    return $TradeVolumeResponse
}
