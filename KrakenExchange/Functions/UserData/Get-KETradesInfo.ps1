function Get-KETradesInfo {
    <#
    .SYNOPSIS
    Retrieves information about trades for a given transaction ID on the Kraken exchange.

    .DESCRIPTION
    The Get-KETradesInfo function retrieves information about trades for a given transaction ID on the Kraken exchange using the Kraken API. The function requires an API key and secret for authentication.

    .PARAMETER ApiKey
    The API key to use for authentication. This parameter is optional, and if not provided, the function will attempt to retrieve the API key from the user's environment variables.

    .PARAMETER ApiSecret
    Encoded API secret to use for authentication. This parameter is optional, and if not provided, the function will attempt to retrieve the API secret from the user's environment variables.

    .PARAMETER txid
    The transaction ID for which to retrieve trade information.

    .PARAMETER Trades
    A switch parameter that indicates whether to include the trades in the response. If not specified, trades will be excluded.

    .EXAMPLE
    PS C:\> Get-KETradesInfo -txid "ABCD1234" -Trades

    Retrieves information about trades for the transaction ID "ABCD1234" and includes the trades in the response.

    .EXAMPLE
    PS C:\> Get-KETradesInfo -txid "ABCD1234" -ApiKey "1234567890" -ApiSecret "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    Retrieves information about trades for the transaction ID "ABCD1234" using the specified API key and secret.

    .LINK
    For more information, see the Kraken API documentation:
    https://docs.kraken.com/rest/#tag/User-Data/operation/getTradesInfo

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

        [Parameter(Mandatory = $true)]
        [Alias("Transaction IDs", "Transaction ID")]
        [string]$txid,

        [bool]$Trades = $false
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
        $TradesInfoMethod = "/0/private/QueryTrades"
        $TradesInfoUrl = $endpoint + $TradesInfoMethod
    
        # Generate nonce for API request
        $nonce = [Math]::Round((New-TimeSpan -Start "1/1/1970").TotalMilliseconds)
    
        # Define parameters for API request
        $TradesInfoParam = [ordered]@{
            "nonce"             = $nonce
            "txid"              = $txid
            "trades"            = $Trades
        }
    
        Write-Debug ($MyInvocation.ScriptName | Out-String)
        Write-Debug ($MyInvocation.mycommand | Out-String)
        Write-Debug ($MyInvocation.BoundParameters | Out-String)
        Write-Debug ($MyInvocation.InvocationName | Out-String)
        Write-Debug ($MyInvocation.PipelineLength | Out-String)
        Write-Debug ($MyInvocation.ScriptLineNumber | Out-String)
        Write-Debug "TradesInfoParam: $($TradesInfoParam | out-string)"
    
        # Generate signature for API request
        $signature = Set-KESignature -Payload $TradesInfoParam -URI $TradesInfoMethod -ApiSecret $ApiSecretEncoded
    
        # Define headers for API request
        $TradesInfoHeaders = @{ 
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
        Write-Debug "TradesInfoHeaders: $($TradesInfoHeaders | out-string)"

        # Send API request and retrieve response
        $TradesInfoResponse = Invoke-RestMethod -Uri $TradesInfoUrl -Method Post -body $TradesInfoParam -Headers $TradesInfoHeaders
    
        # Return the response
        return $TradesInfoResponse
    }
    catch {

        return $_.exception.message
    
    }    
}
