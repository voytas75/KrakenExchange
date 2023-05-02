function New-KEEnvVariable {
    <#
    .SYNOPSIS
        Creates a new user-level environment variable with the specified name and value.
    
    .DESCRIPTION
        This function sets a user-level environment variable using the specified name and value. 
        The value can be any valid string value. Input validation and sanitization are implemented to prevent security breaches or system damage.

    .NOTES
        This function is only supported on Windows systems.
        
        The KrakenExchange PowerShell module is not affiliated with or endorsed by Kraken exchange.
        
        Author: wnapierala [@] hotmail.com, chatGPT, writegpt.ai
        Date: 04.2023

    .PARAMETER envName
        The name of the environment variable to create. 
        
    .PARAMETER envValue
        The value to set for the environment variable. 
        
    .EXAMPLE
        New-KEEnvVariable -envName "MyVar" -envValue "12345"
        
        This command creates a new environment variable named "MyVar" with the value "12345".
    
    .EXAMPLE
        New-KEEnvVariable -envName "MY_VAR" -envValue "Hello World"
        Creates a new environment variable named "MY_VAR" with the value "Hello World".

    .EXAMPLE
        New-KEEnvVariable -envName "BAD NAME!" -envValue "123"
        Throws an error because the environment variable name contains invalid characters.

    .EXAMPLE
        New-KEEnvVariable -envName "MY_VAR" -envValue ""
        Throws an error because the environment variable value is empty.
    
    .INPUTS
        None.

    .OUTPUTS
        None.
        
    .LINK
        https://docs.microsoft.com/en-us/dotnet/api/system.environment.setenvironmentvariable
        
    #>   
    [CmdletBinding()]
    param (
           [Parameter(Mandatory=$true)]
           [ValidateNotNullOrEmpty()]
           [string]$envName, 
           [Parameter(Mandatory=$true)]
           [ValidateNotNullOrEmpty()]
           [string]$envValue
    )

    # Validate that $envName and $envValue are safe to use as environment variables.
    if (-not ($envName -match '[^\w\d_]+') -and -not ([string]::IsNullOrWhiteSpace($envName)) -and -not ([string]::IsNullOrWhiteSpace($envValue))) {
        # If validation is successful, set the environment variable.
        [System.Environment]::SetEnvironmentVariable($envName, $envValue, "User")
        Write-Verbose "${envName}: ${envValue}, '$([System.Environment]::GetEnvironmentVariable($envName,"user"))'"
    }
    else {
        # If validation fails, throw an error.
        Throw "Invalid environment variable name or value."
    }
}
