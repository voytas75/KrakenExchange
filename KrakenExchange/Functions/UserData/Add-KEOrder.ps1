function Add-KEOrder {
    <#

    .LINK
    For more information, see the Kraken API documentation:
    https://docs.kraken.com/rest/#tag/User-Data/operation/getAddOrder

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

        [string]$UserRefID,

        [Parameter(Mandatory = $true)]
        [ValidateSet("market", "limit", "stop-loss", "take-profit", "stop-loss-limit", "take-profit-limit", "settle-position")]
        [Alias("Order")]
        [string]$OrderType,

        [Parameter(Mandatory = $true)]
        [ValidateSet("buy", "sell")]
        [Alias("Direction")]
        [string]$Type, 

        [Parameter(Mandatory = $true)]
        [string]$Volume, 

        [string]$DisplayVol,

        [Parameter(Mandatory = $true)]
        [string]$Pair,

        [string]$Price,

        [Alias("SecondaryPrice")]
        [string]$Price2,

        [ValidateSet("index", "last")]
        [string]$Trigger = "last",

        [string]$Leverage = "none",

        [bool]$ReduceOnly = $false,

        [ValidateSet("cancel-newest", "cancel-oldest", "cancel-both")]
        [string]$StpType = "cancel-newest",

        [string]$oflags,

        [ValidateSet("GTC", "IOC", "GTD")]
        [string]$timeinforce = "GTC",

        [string]$starttm = "0",

        [string]$expiretm = "0",

        [ValidateSet("limit", "stop-loss", "take-profit", "stop-loss-limit", "take-profit-limit")]
        [string]$close_ordertype,

        [string]$close_price,

        [string]$close_price2,

        [string]$deadline,

        [bool]$validate = $false
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
        $AddOrderMethod = "/0/private/AddOrder"
        $AddOrderUrl = $endpoint + $AddOrderMethod
    
        # Generate nonce for API request
        $nonce = [Math]::Round((New-TimeSpan -Start "1/1/1970").TotalMilliseconds)

        
        # Define parameters for API request
        $AddOrderParam = [ordered]@{
            "nonce"       = $nonce
            "userref"     = $UserRefID
            "ordertype"   = $ordertype
            "type"        = $type
            "volume"      = $volume
            "displayvol"  = $displayvol
            "pair"        = $pair
            "price"       = $price
            "price2"      = $Price2
            "trigger"     = $Trigger
            "leverage"    = $leverage
            "reduce_only" = $reduce_only
            "stptype"     = $stptype
            "oflags"      = $oflags
            "timeinforce" = $timeinforce
            "starttm"     = $starttm
            "expiretm"    = $expiretm
            

        }
    
        Write-Debug $MyInvocation.ScriptName
        Write-Debug "AddOrderParam: $($AddOrderParam | out-string)"
    
        # Generate signature for API request
        $signature = Set-KESignature -Payload $AddOrderParam -URI $AddOrderMethod -ApiSecret $ApiSecretEncoded
    
        # Define headers for API request
        $AddOrderHeaders = @{ 
            "API-Key"    = $apiKey; 
            "API-Sign"   = $signature; 
            "User-Agent" = $useragent
        }
    
        # Send API request and retrieve response
        $AddOrderResponse = Invoke-RestMethod -Uri $AddOrderUrl -Method Post -body $AddOrderParam -Headers $AddOrderHeaders
    
        # Return the response
        return $AddOrderResponse
    }
    catch {

        return $_.exception.message
    
    }    
}
