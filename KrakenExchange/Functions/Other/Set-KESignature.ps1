function Set-KESignature {
    <#
    .SYNOPSIS
    Calculates the signature for a Kraken API request.

    .DESCRIPTION
    Calculates the signature for a Kraken API request using the specified payload, URI, and API secret.

    .PARAMETER Payload
    The payload for the API request, as an OrderedDictionary.

    .PARAMETER URI
    The URI for the API request, as a string.

    .PARAMETER api_secret
    The API secret for the Kraken account, as a string.

    .EXAMPLE
    PS C:\> $payload = [System.Collections.Specialized.OrderedDictionary]::new()
    PS C:\> $payload.Add("nonce", [int64]([DateTime]::UtcNow - (New-Object DateTime 1970, 1, 1, 0, 0, 0, 0, ([DateTimeKind]::Utc))).TotalMilliseconds
    PS C:\> $payload.Add("ordertype", "limit")
    PS C:\> $payload.Add("type", "buy")
    PS C:\> $payload.Add("pair", "XXBTZUSD")
    PS C:\> $payload.Add("price", "9000")
    PS C:\> $payload.Add("volume", "0.01")
    PS C:\> Set-APIKrakenSignature -Payload $payload -URI "/0/private/AddOrder" -api_secret "KrakenAPIsecret"

    .NOTES
    The KrakenExchange PowerShell module is not affiliated with or endorsed by Kraken exchange.
    Author: wnapierala [@] hotmail.com, chatGPT
    Date: 03.2023

        Both [System.Security.Cryptography.HashAlgorithm]::Create('SHA256') and [System.Security.Cryptography.SHA256]::Create() create an instance of the SHA256 hashing algorithm provided by the .NET Framework's System.Security.Cryptography namespace. The difference between them is that the former creates an instance of the HashAlgorithm class and the latter creates an instance of the SHA256 class, which inherits from HashAlgorithm.
    The HashAlgorithm class is an abstract base class that provides the basic functionality common to all hash algorithms. It defines the ComputeHash method, which computes the hash value for a given input, as well as other methods and properties that are common to all hash algorithms. When you create an instance of the SHA256 algorithm using [System.Security.Cryptography.HashAlgorithm]::Create('SHA256'), you are creating an instance of the SHA256Managed class, which is a concrete implementation of the SHA256 algorithm that inherits from HashAlgorithm.
    On the other hand, when you create an instance of the SHA256 algorithm using [System.Security.Cryptography.SHA256]::Create(), you are creating an instance of the SHA256Cng class, which is a concrete implementation of the SHA256 algorithm that inherits directly from SHA256.
    In general, it is recommended to use the specific algorithm class, such as SHA256, rather than the HashAlgorithm base class, as it provides a more strongly-typed interface and may have additional functionality specific to that algorithm. However, both methods should work fine for creating an instance of the SHA256 algorithm.
    [System.Security.Cryptography.HMAC]::Create("HMACSHA512") - it works too
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "The payload for the API request, as an OrderedDictionary.")]
        [System.Collections.Specialized.OrderedDictionary]$Payload,

        [Parameter(Mandatory = $true, HelpMessage = "The URI for the API request, as a string.")]
        [string]$URI,

        [Parameter(Mandatory = $false, HelpMessage = "The API secret for the Kraken account, as a securestring.")]
        [string]$ApiSecret = ([Environment]::GetEnvironmentVariable('KE_API_SECRET',"User"))
    )
    Write-Debug $MyInvocation.ScriptName
    Write-Debug "APIKey env.: $([Environment]::GetEnvironmentVariable('KE_API_KEY', "User"))"
    Write-Debug "APIKey arg.: ${ApiKey}"
    Write-Debug "APISecret env.: $([Environment]::GetEnvironmentVariable('KE_API_SECRET', "User"))"
    Write-Debug "APISecret arg.: ${ApiSecret}"

    if (-not $ApiSecret) {
        [securestring]$ApiSecret = Read-Host "API Secret" -AsSecureString 
        [string]$ApiSecretEncoded = $ApiSecret | ConvertFrom-SecureString
        [Environment]::SetEnvironmentVariable("KE_API_SECRET", $ApiSecretEncoded, "User")
    } else {
        $ApiSecretEncoded = $ApiSecret
    }
   
    $ApiSecretPlainText = $ApiSecretEncoded | ConvertTo-SecureString | ConvertFrom-SecureString -AsPlainText

    # Convert the payload to a URL-encoded string
    $url_encoded_payload = ($payload.GetEnumerator() | ForEach-Object { $_.Name + "=" + $_.Value }) -join "&"

    # Create an instance of the SHA256 hashing algorithm
    $sha = [System.Security.Cryptography.SHA256]::Create()

    # Compute the SHA256 hash of the nonce and URL-encoded payload
    $shahash = $sha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($Payload["nonce"].ToString() + $url_encoded_payload))

    # Create an instance of the HMAC-SHA512 algorithm
    $mac = New-Object System.Security.Cryptography.HMACSHA512

    # Set the key to the API secret converted to bytes
    $api_secret_bytes = [System.Convert]::FromBase64String($ApiSecretPlainText)
    $mac.Key = $api_secret_bytes

    # Compute the HMAC-SHA512 hash of the URI and SHA256 hash
    $machash = $mac.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($URI) + $shahash)

    # Convert the result to a Base64-encoded string and return it
    $signature = [System.Convert]::ToBase64String($machash)
    return $signature
}
