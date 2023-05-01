function Disconnect-KExchange {
    <#
    .SYNOPSIS
        Disconnects from the Kraken exchange API by resetting environment variables.
    .NOTES
        The KrakenExchange PowerShell module is not affiliated with or endorsed by Kraken exchange.
        Author: wnapierala [@] hotmail.com, chatGPT
        Date: 04.2023
    .EXAMPLE
        Disconnect-KrakenExchange
    #>
    [CmdletBinding()]
    param (
    )

    Write-Debug $MyInvocation.ScriptName
    Write-Debug "APIKey env.: $([Environment]::GetEnvironmentVariable('KE_API_KEY', "User"))"
    Write-Debug "APIKey arg.: ${ApiKey}"
    Write-Debug "APISecret env.: $([Environment]::GetEnvironmentVariable('KE_API_SECRET', "User"))"
    Write-Debug "APISecret arg.: ${ApiSecret}"

    try {
        [Environment]::SetEnvironmentVariable("KE_API_KEY", "", "User")
        [Environment]::SetEnvironmentVariable("KE_API_SECRET", "", "User")
        [Environment]::SetEnvironmentVariable("KE_WEBSOCKET_TOKEN", "", "User")
        return $true
    }
    catch [System.Management.Automation.MethodInvocationException] {
        Write-Error "Failed to reset environment variables: $_"
        return $false
    }
    catch {
        Write-Error $_.Exception.Message
        return $false
    }    
}
