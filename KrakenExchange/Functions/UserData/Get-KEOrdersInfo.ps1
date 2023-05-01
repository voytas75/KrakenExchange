function Get-KEOrdersInfo {
    <#
    .SYNOPSIS
    Retrieves information about a specific order from the Kraken exchange.

    .DESCRIPTION
    The Get-KEOrdersInfo function retrieves information about a specific order from the Kraken exchange using the Kraken API. This function requires API keys from the Kraken exchange.

    .PARAMETER ApiKey
    The API key for the Kraken exchange. This parameter is optional, but if not specified, it will attempt to retrieve the key from the environment variable KE_API_KEY.

    .PARAMETER ApiSecret
    Encoded API secret for the Kraken exchange. This parameter is optional, but if not specified, it will attempt to retrieve the secret from the environment variable KE_API_SECRET.

    .PARAMETER Trades
    If this parameter is set to true, the API will also return information about the trades associated with the order.

    .PARAMETER UserRefID
    The user reference ID for the order. This parameter is optional and defaults to 0.

    .PARAMETER txid
    The transaction ID of the order to retrieve information for. This parameter is mandatory.

    .PARAMETER consolidate_taker
    If this parameter is set to true, the API will consolidate orders that have the same taker fee rate. This parameter is optional and defaults to true.

    .EXAMPLE
    PS C:\> Get-KEOrdersInfo -txid "OT5GZQ-7VBLR-5J4TEA"

    Retrieves information about the order with the specified transaction ID.

    .LINK
    For more information, see the Kraken API documentation:
    https://docs.kraken.com/rest/#tag/User-Data/operation/getOrdersInfo

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

        [int]$UserRefID = "0",

        [Parameter(Mandatory = $true)]
        [string]$txid,

        [bool]$consolidate_taker = $true


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
        $OrdersInfoMethod = "/0/private/QueryOrders"
        $OrdersInfoUrl = $endpoint + $OrdersInfoMethod
    
        # Generate nonce for API request
        $nonce = [Math]::Round((New-TimeSpan -Start "1/1/1970").TotalMilliseconds)
    
        # Define parameters for API request
        $OrdersInfoParam = [ordered]@{
            "nonce"             = $nonce
            "trades"            = $Trades
            "userref"           = $UserRefID
            "txid"              = $txid
            "consolidate_taker" = $consolidate_taker
        }
    
        Write-Debug $MyInvocation.ScriptName
        Write-Debug "OrdersInfoParam: $($OrdersInfoParam | out-string)"
    
        # Generate signature for API request
        $signature = Set-KESignature -Payload $OrdersInfoParam -URI $OrdersInfoMethod -ApiSecret $ApiSecretEncoded
    
        Write-Debug ($MyInvocation.mycommand | Out-String)
        Write-Debug ($MyInvocation.scriptname | Out-String)
        Write-Debug ($MyInvocation.BoundParameters | Out-String)
        Write-Debug ($MyInvocation.InvocationName | Out-String)
        Write-Debug ($MyInvocation.PipelineLength | Out-String)
        Write-Debug ($MyInvocation.ScriptLineNumber | Out-String)
        Write-Debug "signature: $($signature | out-string)"

        # Define headers for API request
        $OrdersInfoHeaders = @{ 
            "API-Key"    = $apiKey; 
            "API-Sign"   = $signature; 
            "User-Agent" = $useragent
        }
    
        # Send API request and retrieve response
        $OrdersInfoResponse = Invoke-RestMethod -Uri $OrdersInfoUrl -Method Post -body $OrdersInfoParam -Headers $OrdersInfoHeaders
    
        # Return the response
        return $OrdersInfoResponse
    }
    catch {

        return $_.exception.message
    
    }    
}
