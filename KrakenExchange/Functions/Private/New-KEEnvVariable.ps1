function New-KEEnvVariable {
    <#
    .SYNOPSIS
        A short one-line action-based description, e.g. 'Tests if a function is valid'
    .NOTES
        Information or caveats about the function e.g. 'This function is not supported in Linux'
    #>   
    [CmdletBinding()]
    param (
           [string]$envName, 
           [string]$envValue
    )

    #env:$envName = $envValue
    [System.Environment]::SetEnvironmentVariable($envName, $envValue, "User")
    
    Write-Verbose "${envName}: ${envValue}, '$([System.Environment]::GetEnvironmentVariable($envName,"user"))'"

}