function Get-KEOpenOrders {
    <#
    
    .LINK
    For more information, see the Kraken API documentation:
    https://docs.kraken.com/rest/#tag/User-Data/operation/getOpenOrders

    .NOTES
    The KrakenExchange PowerShell module is not affiliated with or endorsed by Kraken exchange.
    Author: wnapierala [@] hotmail.com, chatGPT
    Date: 04.2023
    #>    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$ApiKey = ([Environment]::GetEnvironmentVariable('KE_API_KEY', 'user')),

        [Parameter(Mandatory = $false)]
        [Alias("encodedAPISecret")]
        [string]$ApiSecret = ([Environment]::GetEnvironmentVariable('KE_API_SECRET', 'user')),

        [bool]$Trades = $false,

        [string]$UserRefID

    )

    Write-Debug $MyInvocation.ScriptName
    Write-Debug "APIKey env.: $([Environment]::GetEnvironmentVariable('KE_API_KEY', "User"))"
    Write-Debug "APIKey arg.: ${ApiKey}"
    Write-Debug "APISecret env.: $([Environment]::GetEnvironmentVariable('KE_API_SECRET', "User"))"
    Write-Debug "APISecret arg.: ${ApiSecret}"

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
    $OpenOrdersMethod = "/0/private/OpenOrders"
    $OpenOrdersUrl = $endpoint + $OpenOrdersMethod

    # Generate nonce for API request
    $nonce = [Math]::Round((New-TimeSpan -Start "1/1/1970").TotalMilliseconds)

    # Define parameters for API request
    if (-not $UserRefID) {
        $OpenOrdersParam = [ordered]@{
            "nonce"   = $nonce
            "trades"  = $Trades
        }
    }
    else {
        $OpenOrdersParam = [ordered]@{
            "nonce"   = $nonce
            "trades"  = $Trades
            "userref" = $UserRefID
        }
    }
    # Generate signature for API request
    $signature = Set-KESignature -Payload $OpenOrdersParam -URI $OpenOrdersMethod -ApiSecret $ApiSecretEncoded

    # Define headers for API request
    $OpenOrdersHeaders = @{ 
        "API-Key"    = $apiKey; 
        "API-Sign"   = $signature; 
        "User-Agent" = $useragent
    }

    # Send API request and retrieve response
    $OpenOrdersResponse = Invoke-RestMethod -Uri $OpenOrdersUrl -Method Post -body $OpenOrdersParam -Headers $OpenOrdersHeaders
    
    # Return the response
    return $OpenOrdersResponse
}
