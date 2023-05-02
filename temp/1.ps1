[CmdletBinding()]
param (
    [Parameter()]
    [ValidatePattern('^[a-zA-Z0-9]+$')]
    [string]$ApiKey = ([Environment]::GetEnvironmentVariable('KE_API_KEY', 'user')),

    [Parameter()]
    [Alias("encodedAPISecret")]
    [ValidatePattern('^[a-zA-Z0-9/+]*={0,2}$')]
    [string]$ApiSecret = ([Environment]::GetEnvironmentVariable('KE_API_SECRET', 'user'))
)

if (-not $ApiKey) {
    throw "API key not provided."
}

if (-not $ApiSecret) {
    throw "API secret not provided."
}

# Remove any special characters or escape sequences from the input values
$ApiKey = $ApiKey.Replace("`n",'').Replace("`r",'')
$ApiSecret = $ApiSecret.Replace("`n",'').Replace("`r",'')

# Use secure storage for the API key and secret
$ApiKey = Get-Secret -Name "KE_API_KEY"
$ApiSecret = Get-Secret -Name "KE_API_SECRET"

# Implement rate limiting
$RateLimit = New-Object System.Collections.Generic.Dictionary[string,int]
$RateLimit.Add('AccountBalance', 10)
$LastRequestTime = $RateLimit | ForEach-Object { [datetime]::MinValue }

# Check rate limit before making a request
$Now = Get-Date
if (($Now - $LastRequestTime['AccountBalance']).TotalSeconds -lt 6) {
    throw "Rate limit exceeded. Please wait a few seconds before making another request."
}

# Make the API request
try {
    $AccountBalanceResponse = Get-KEAccountBalance -ApiKey $ApiKey -ApiSecret $ApiSecret
    $LastRequestTime['AccountBalance'] = $Now
    return $AccountBalanceResponse
}
catch {
    throw "Failed to retrieve account balance: $_"
}
