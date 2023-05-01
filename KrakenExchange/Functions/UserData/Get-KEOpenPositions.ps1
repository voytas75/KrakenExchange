function Get-KEOpenPositions {
    <#
    .SYNOPSIS
    Retrieves a list of open positions for the user's account on Kraken exchange.

    .DESCRIPTION
    The Get-KEOpenPositions function sends an authenticated request to the Kraken API to retrieve a list of open positions
    for the user's account. This function requires an API key and secret to authenticate the request. If the API secret is
    not provided, the function will prompt the user to enter their API key and secret interactively.

    .PARAMETER ApiKey
    The API key used to authenticate the request. This parameter is optional. If not provided, the function will attempt
    to retrieve the API key from the 'KE_API_KEY' environment variable.

    .PARAMETER ApiSecret
    Encoded API secret used to authenticate the request. This parameter is optional. If not provided, the function will prompt
    the user to enter their API key and secret interactively.

    .PARAMETER txid
    A comma delimited list of transaction IDs to restrict output to. This parameter is optional.

    .PARAMETER docalcs
    Whether or not to include profit/loss calculations. This parameter is optional and defaults to $false.

    .PARAMETER consolidation
    How to consolidate the positions. This parameter is optional and defaults to 'market'.

    .EXAMPLE
    PS C:> Get-KEOpenPositions -docalcs $true

    Retrieves open positions and includes profit/loss calculation for each position.

    .EXAMPLE
    PS C:> Get-KEOpenPositions -txid 'O2TQZ6-KHJ6U-7SDXNW'

    Retrieves open positions for a specific transaction ID.

    .LINK
    For more information, see the Kraken API documentation:
    https://docs.kraken.com/rest/#tag/User-Data/operation/getOpenPositions

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

        [Parameter(Mandatory = $false)]
        [Alias("Transaction IDs", "Transaction ID")]
        [string]$txid,

        [bool]$docalcs = $false,

        [string]$consolidation = "market"
    )

    try {
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
        $OpenPositionsMethod = "/0/private/OpenPositions"
        $OpenPositionsUrl = $endpoint + $OpenPositionsMethod
    
        # Generate nonce for API request
        $nonce = [Math]::Round((New-TimeSpan -Start "1/1/1970").TotalMilliseconds)
    
        # Define parameters for API request
        $OpenPositionsParam = [ordered]@{
            "nonce"         = $nonce
            "txid"          = $txid
            "docalcs"       = $docalcs
            "consolidation" = $consolidation
        }
    
        Write-Debug ($MyInvocation.ScriptName | Out-String)
        Write-Debug ($MyInvocation.mycommand | Out-String)
        Write-Debug ($MyInvocation.BoundParameters | Out-String)
        Write-Debug ($MyInvocation.InvocationName | Out-String)
        Write-Debug ($MyInvocation.PipelineLength | Out-String)
        Write-Debug ($MyInvocation.ScriptLineNumber | Out-String)
        Write-Debug "OpenPositionsParam: $($OpenPositionsParam | out-string)"
    
        # Generate signature for API request
        $signature = Set-KESignature -Payload $OpenPositionsParam -URI $OpenPositionsMethod -ApiSecret $ApiSecretEncoded
    
        # Define headers for API request
        $OpenPositionsHeaders = @{ 
            "API-Key"    = $apiKey; 
            "API-Sign"   = $signature; 
            "User-Agent" = $useragent
        }
    
        Write-Debug ($MyInvocation.ScriptName | Out-String)
        Write-Debug ($MyInvocation.mycommand | Out-String)
        Write-Debug ($MyInvocation.BoundParameters | Out-String)
        Write-Debug ($MyInvocation.InvocationName | Out-String)
        Write-Debug ($MyInvocation.PipelineLength | Out-String)
        Write-Debug ($MyInvocation.ScriptLineNumber | Out-String)
        Write-Debug "OpenPositionsHeaders: $($OpenPositionsHeaders | out-string)"

        # Send API request and retrieve response
        $OpenPositionsResponse = Invoke-RestMethod -Uri $OpenPositionsUrl -Method Post -body $OpenPositionsParam -Headers $OpenPositionsHeaders
    
        # Return the response
        return $OpenPositionsResponse
    }
    catch {

        return $_.exception.message
    
    }    
}
