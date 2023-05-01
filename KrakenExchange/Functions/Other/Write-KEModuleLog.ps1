function Write-KEModuleLog {
    <#
    .SYNOPSIS
        Writes a log message to a file for a specific module.
    .DESCRIPTION
        The Write-KEModuleLog function creates a log file for a specific module and writes a message to that file.
    .PARAMETER ModuleName
        The name of the module for which to create a log file.
    .PARAMETER Message
        The log message to write to the file.
    .EXAMPLE
        Write-KEModuleLog -ModuleName "MyModule" -Message "An error occurred in MyModule."
    .NOTES
        The KrakenExchange PowerShell module is not affiliated with or endorsed by Kraken exchange.
        Author: wnapierala [@] hotmail.com, chatGPT
        Date: 04.2023
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ModuleName,
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    # Get the path to the user's Documents folder
    $documentsFolder = [Environment]::GetFolderPath("MyDocuments")

    # Create a subfolder for the logs
    $logFolder = Join-Path -Path $documentsFolder -ChildPath "PowerShellLogs"

    if (-not (Test-Path -Path $logFolder -PathType Container)) {
        # Create the log folder if it doesn't exist
        New-Item -Path $logFolder -ItemType Directory | Out-Null
    }

    # Create a subfolder for the module logs
    $moduleLogFolder = Join-Path -Path $logFolder -ChildPath $ModuleName

    if (-not (Test-Path -Path $moduleLogFolder -PathType Container)) {
        # Create the module log folder if it doesn't exist
        New-Item -Path $moduleLogFolder -ItemType Directory | Out-Null
    }

    # Create the log file path
    $logFile = Join-Path -Path $moduleLogFolder -ChildPath "$ModuleName.log"

    # Write a message to the log file
    "$(Get-Date) - $Message" | Out-File -FilePath $logFile -Append
}
