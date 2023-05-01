function Get-KETradesHistory {
    <#
    .SYNOPSIS
    Retrieves trades history from Kraken exchange API.

    .DESCRIPTION
    The Get-KETradesHistory function retrieves trades history from Kraken exchange API.
    It requires API Key and API Secret to be provided or retrieved from the environment variables.
    The function uses the following parameters:
    - ApiKey: API key for the Kraken exchange API. Optional if the 'KE_API_KEY' environment variable is set.
    - ApiSecret: API secret for the Kraken exchange API. Optional if the 'KE_API_SECRET' environment variable is set.
    - Type: Filter for the type of trades to retrieve. Possible values are "all", "any position", "closed position", "closing position", "no position". Default value is "all".
    - Trades: Indicates whether or not to include trades. Default value is $false.
    - StartDate: Starting date to retrieve trades history. Optional.
    - EndDate: Ending date to retrieve trades history. Optional.
    - ofs: Offset for pagination. Optional.
    - consolidate_taker: Consolidate taker information. Default value is $true.

    .PARAMETER ApiKey
    API key for the Kraken exchange API.

    .PARAMETER ApiSecret
    Encoded API secret for the Kraken exchange API.

    .PARAMETER Type
    Filter for the type of trades to retrieve. Possible values are "all", "any position", "closed position", "closing position", "no position". Default value is "all".

    .PARAMETER Trades
    Indicates whether or not to include trades. Default value is $false.

    .PARAMETER StartDate
    Starting date to retrieve trades history.

    .PARAMETER EndDate
    Ending date to retrieve trades history.

    .PARAMETER ofs
    Offset for pagination.

    .PARAMETER consolidate_taker
    Consolidate taker information. Default value is $true.

    .EXAMPLE
    PS C:\> Get-KETradesHistory -ApiKey "your_api_key" -ApiSecret "your_encoded_api_secret" -Type "all" -Trades $true -StartDate "2022-01-01" -EndDate "2022-01-31" -ofs 0 -consolidate_taker $true

    .LINK
    For more information, see the Kraken API documentation:
    https://docs.kraken.com/rest/#tag/User-Data/operation/getTradesHistory

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

        [ValidateSet("all", "any position", "closed position", "closing position", "no position")]
        [string]$Type = "all",

        [bool]$Trades = $false,

        [datetime]$StartDate,

        [datetime]$EndDate,

        [Alias("OffsetForPagination")]
        [int]$ofs,

        [bool]$consolidate_taker = $true
    )

    try {
        Write-Debug ($MyInvocation.ScriptName | Out-String)
        Write-Debug ($MyInvocation.mycommand | Out-String)
        Write-Debug ($MyInvocation.BoundParameters | Out-String)
        Write-Debug ($MyInvocation.InvocationName | Out-String)
        Write-Debug ($MyInvocation.PipelineLength | Out-String)
        Write-Debug ($MyInvocation.ScriptLineNumber | Out-String)
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
        $TradesHistoryMethod = "/0/private/TradesHistory"
        $TradesHistoryUrl = $endpoint + $TradesHistoryMethod
    
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
        $TradesHistoryParam = [ordered]@{
            "nonce"             = $nonce
            "type"              = $Type
            "trades"            = $Trades
            "start"             = $StartDate_unixTimestamp
            "end"               = $EndDate_unixTimestamp
            "ofs"               = $ofs
            "consolidate_taker" = $consolidate_taker
        }
    
        # Generate signature for API request
        $signature = Set-KESignature -Payload $TradesHistoryParam -URI $TradesHistoryMethod -ApiSecret $ApiSecretEncoded

        # Define headers for API request
        $TradesHistoryHeaders = @{ 
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
        Write-Debug "TradesHistoryHeaders: $($TradesHistoryHeaders | out-string)"

        # Send API request and retrieve response
        $TradesHistoryResponse = Invoke-RestMethod -Uri $TradesHistoryUrl -Method Post -body $TradesHistoryParam -Headers $TradesHistoryHeaders
    
        # Return the response
        return $TradesHistoryResponse
    }
    catch {

        return $_.exception.message
    
    }    
}
