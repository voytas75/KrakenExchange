function Get-KEWebsocketsToken {
    <#
    .SYNOPSIS
        Generates a WebSockets token to be used with the KrakenExchange PowerShell module.
    .DESCRIPTION
        Generates a WebSockets token to be used with the KrakenExchange PowerShell module. The function prompts for the API Key and API Secret if they are not provided as parameters.
    .PARAMETER ApiKey
        The API Key for the KrakenExchange API. If not provided, the function will prompt for it.
    .PARAMETER ApiSecret
        The API Secret for the KrakenExchange API. If not provided, the function will prompt for it.
    .EXAMPLE
        PS> Get-KEWebsocketsToken
        Generates a WebSockets token using the API Key and API Secret stored in the environment variables $env:ApiKey and $env:ApiSecret.
    .EXAMPLE
        PS> Get-KEWebsocketsToken -ApiKey "your-api-key" -ApiSecret "your-api-secret"
        Generates a WebSockets token using the provided API Key and API Secret.
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
        [string]$ApiSecret = ([Environment]::GetEnvironmentVariable('KE_API_SECRET', 'user'))
    )
    
    if (-not $ApiKey) {
        $ApiKey = Read-Host "Enter API Key"
        [Environment]::SetEnvironmentVariable("KE_API_KEY", $ApiKey, "User")
    
    }

    [Environment]::SetEnvironmentVariable("KE_API_KEY", $ApiKey, "User")

    if (-not $ApiSecret) {
        [securestring]$ApiSecret = Read-Host "Enter API Secret" -AsSecureString
        [string]$ApiSecretEncoded = $ApiSecret | ConvertFrom-SecureString
        [Environment]::SetEnvironmentVariable("KE_API_SECRET", $ApiSecretEncoded, "User")
    }
    else {
        $ApiSecretEncoded = $ApiSecret
    }

    $UserAgent = "Powershell Module KrakenExchange/1.0"
    $endpoint = "https://api.kraken.com"
    $KEWebsocketsTokenMethod = "/0/private/GetWebSocketsToken"
    $KEWebsocketsTokenUrl = $endpoint + $KEWebsocketsTokenMethod

    $nonce = [Math]::Round((New-TimeSpan -Start "1/1/1970").TotalMilliseconds)

    $KEWebsocketsTokenParam = [ordered]@{
        "nonce" = $nonce
    }

    $signature = Set-KESignature -Payload $KEWebsocketsTokenParam -URI $KEWebsocketsTokenMethod -ApiSecret $ApiSecretEncoded

    $KEWebsocketsTokenHeaders = @{ 
        "API-Key"    = $apiKey; 
        "API-Sign"   = $signature; 
        "User-Agent" = $useragent
    }

    $KEWebsocketsTokenResponse = Invoke-RestMethod -Uri $KEWebsocketsTokenUrl -Method Post -body $KEWebsocketsTokenParam -Headers $KEWebsocketsTokenHeaders

    return $KEWebsocketsTokenResponse
}
