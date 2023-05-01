function Get-KEClosedOrders {
    <#
    .SYNOPSIS
    Retrieves the closed orders for a Kraken Exchange account.

    .DESCRIPTION
    The Get-KEClosedOrders function sends an API request to the Kraken Exchange to retrieve a list of closed orders for a user's account. The function can filter results by specifying a start and end date, offset for pagination, and whether to include trade information.

    .PARAMETER ApiKey
    Specifies the API key for the Kraken Exchange account. If not specified, the function will attempt to retrieve the key from the 'KE_API_KEY' environment variable.

    .PARAMETER ApiSecret
    Specifies encoded API secret for the Kraken Exchange account. If not specified, the function will attempt to retrieve the secret from the 'KE_API_SECRET' environment variable.

    .PARAMETER Trades
    Specifies whether to include trade information for closed orders.

    .PARAMETER UserRefID
    Specifies a user reference ID to filter the results.

    .PARAMETER StartDate
    Specifies a start date for filtering the results. Only orders closed after this date will be returned.

    .PARAMETER EndDate
    Specifies an end date for filtering the results. Only orders closed before this date will be returned.

    .PARAMETER ofs
    Specifies an offset for pagination. Results will be returned starting from this offset.

    .PARAMETER closetime
    Specifies the type of orders to include. Valid options are 'open', 'close', or 'both'.

    .LINK
    For more information, see the Kraken API documentation:
    https://docs.kraken.com/rest/#tag/User-Data/operation/getClosedOrders

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

        [string]$UserRefID,

        [datetime]$StartDate,

        [datetime]$EndDate,

        [Alias("OffsetForPagination")]
        [int]$ofs,

        [ValidateSet("open", "close", "both")]
        [string]$closetime = "both"


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
        $ClosedOrdersMethod = "/0/private/ClosedOrders"
        $ClosedOrdersUrl = $endpoint + $ClosedOrdersMethod
    
        # Generate nonce for API request
        $nonce = [Math]::Round((New-TimeSpan -Start "1/1/1970").TotalMilliseconds)
    
        if ($StartDate) {
            $StartDate_unixTimestamp = [Math]::Round((New-TimeSpan -Start "1/1/1970" -End $StartDate).TotalSeconds)
        }
        else {
            $StartDate_unixTimestamp = 0
        }
    
        if ($EndDate) {
            $EndDate_unixTimestamp = [Math]::Round((New-TimeSpan -Start "1/1/1970" -End $EndDate).TotalSeconds)
        }
        else {
            $EndDate_unixTimestamp = [Math]::Round((New-TimeSpan -Start "1/1/1970").TotalSeconds)
        }
        
        # Define parameters for API request
        $ClosedOrdersParam = [ordered]@{
            "nonce"     = $nonce
            "trades"    = $Trades
            "userref"   = $UserRefID
            "start"     = $StartDate_unixTimestamp
            "end"       = $EndDate_unixTimestamp
            "ofs"       = $ofs
            "closetime" = $closetime
        }
    
        Write-Debug $MyInvocation.ScriptName
        Write-Debug "ClosedOrdersParam: $($ClosedOrdersParam | out-string)"
    
        # Generate signature for API request
        $signature = Set-KESignature -Payload $ClosedOrdersParam -URI $ClosedOrdersMethod -ApiSecret $ApiSecretEncoded
    
        # Define headers for API request
        $ClosedOrdersHeaders = @{ 
            "API-Key"    = $apiKey; 
            "API-Sign"   = $signature; 
            "User-Agent" = $useragent
        }
    
        # Send API request and retrieve response
        $ClosedOrdersResponse = Invoke-RestMethod -Uri $ClosedOrdersUrl -Method Post -body $ClosedOrdersParam -Headers $ClosedOrdersHeaders
    
        # Return the response
        return $ClosedOrdersResponse
    }
    catch {

        return $_.exception.message
    
    }    
}
