function Get-KEAccountBalance {
    <#
    .SYNOPSIS
    Get the account balance from Kraken API.
    
    .DESCRIPTION
    This function retrieves the account balance from Kraken API using the provided API key and API secret. It generates a nonce for authentication, sets the necessary headers, and makes a POST request to the Kraken API to fetch the account balance.
    
    .PARAMETER ApiKey
    The API key for authentication with Kraken API. 
    
    .PARAMETER ApiSecret
    The encoded API secret for authentication with Kraken API.
    
    .EXAMPLE
    Get-KEAccountBalance -ApiKey "YourApiKey"
    
    Retrieves the account balance from Kraken API using the provided API key and API secret.
    
    .NOTES
    The KrakenExchange PowerShell module is not affiliated with or endorsed by Kraken exchange.
    Author: wnapierala [@] hotmail.com, chatGPT
    Date: 04.2023
    #>    
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$ApiKey = ([Environment]::GetEnvironmentVariable('KE_API_KEY', 'user')),

        [Parameter()]
        [Alias("encodedAPISecret")]
        [string]$ApiSecret = ([Environment]::GetEnvironmentVariable('KE_API_SECRET', 'user'))

    )
    
    Write-Debug $MyInvocation.ScriptName
    Write-Debug "APIKey env.: $([Environment]::GetEnvironmentVariable('KE_API_KEY', "User"))"
    Write-Debug "APIKey arg.: ${ApiKey}"
    Write-Debug "APISecret env.: $([Environment]::GetEnvironmentVariable('KE_API_SECRET', "User"))"
    Write-Debug "APISecret arg.: ${ApiSecret}"

    if (-not $ApiSecret) {
        Disconnect-KExchange
        Connect-KExchange
        $ApiKey = ([Environment]::GetEnvironmentVariable('KE_API_KEY', "User"))
        $ApiSecretEncoded = $ApiSecret = ([Environment]::GetEnvironmentVariable('KE_API_SECRET', "User"))
    }
    else {
        $ApiSecretEncoded = $ApiSecret
    }

    #useragent
    $UserAgent = "Powershell Module KrakenExchange/1.0"
    # Set API endpoint and version
    $endpoint = "https://api.kraken.com"
    $AccountBalanceMethod = "/0/private/Balance"
    $AccountBalanceUrl = $endpoint + $AccountBalanceMethod

    # Generate nonce
    $nonce = [Math]::Round((New-TimeSpan -Start "1/1/1970").TotalMilliseconds)
    # what is nonce: https://support.kraken.com/hc/en-us/articles/360000906023-What-is-a-nonce-

    $AccountBalanceParam = [ordered]@{
        "nonce" = $nonce
    }

    $signature = Set-KESignature -Payload $AccountBalanceParam -URI $AccountBalanceMethod -ApiSecret $ApiSecretEncoded

    $AccountBalanceHeaders = @{ 
        "API-Key"    = $apiKey; 
        "API-Sign"   = $signature; 
        "User-Agent" = $useragent
    }
    $AccountBalanceResponse = Invoke-RestMethod -Uri $AccountBalanceUrl -Method Post -body $AccountBalanceParam -Headers $AccountBalanceHeaders
    return $AccountBalanceResponse
}    
        
 