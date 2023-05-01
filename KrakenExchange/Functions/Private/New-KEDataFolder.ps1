function New-KEDataFolder {
    <#
.SYNOPSIS
    Function to create folders for module data, i.e. coins price history, temp.
.NOTES
    The KrakenExchange PowerShell module is not affiliated with or endorsed by Kraken exchange.
    Author: wnapierala [@] hotmail.com, chatGPT
    Date: 04.2023
#>
    [CmdletBinding()]
    param (
        [ValidateSet("localAppData", "myDocuments")]
        $TargetFolder = "myDocuments"
    )
    
    # Import the necessary .NET namespaces
    Add-Type -AssemblyName System.IO

    $localAppDataPath = ([Environment]::GetFolderPath([Environment+SpecialFolder]::LocalApplicationData))
    $myDocumentsPath = ([Environment]::GetFolderPath([Environment+SpecialFolder]::MyDocuments))
    <#  
    The + symbol in [Environment+SpecialFolder] is used to indicate that SpecialFolder is an enumeration 
    within the Environment class.
    In .NET, the + symbol is used to denote a nested class or enumeration within another class. So, in this 
    case, SpecialFolder is a nested enumeration within the Environment class.
    To use the SpecialFolder enumeration in PowerShell, you need to specify the fully qualified name of 
    the enumeration, which includes both the name of the parent class and the name of the nested enumeration, 
    separated by the + symbol.
    #>    

    $tempPath = ([System.IO.Path]::GetTempPath())

    $RootFolderName = "KrakenExchange"
    $CryptocurrencyPricesName = "CryptocurrencyPrices"
    $LogsName = "Logs"
    $OtherName = "Other"


    switch ($TargetFolder) {
        "myDocuments" { $TargetPath = $myDocumentsPath }
        "localAppData" { $TargetPath = $localAppDataPath }
        Default {}
    }

<#     if ($TargetFolder -eq "myDocuments") {

        $TargetPath = $myDocumentsPath
    }
    elseif ($TargetFolder -eq "localAppData") {
        $TargetPath = $localAppDataPath
    }

 #>    
    # create TEMP folder
    if (-not (Test-Path -Path "${tempPath}${RootFolderName}")) {
        $_TEMPFolder = New-Item -Path $tempPath -Name $RootFolderName -ItemType Directory
    }
    New-KEEnvVariable -envName "KE_TEMP" -envValue "${tempPath}${RootFolderName}"

    # create data folders
    try {
        if (-not (Test-Path -Path "${TargetPath}\${RootFolderName}")) {
            $_RootFolder = New-Item -Path $TargetPath -Name $RootFolderName -ItemType Directory -ErrorAction Stop
        }

        New-KEEnvVariable -envName "KE_ROOTFOLDER" -envValue "${TargetPath}\${RootFolderName}"


    }
    catch {
        Write-Error "Can't create '${RootFolderName}' in '${TargetPath}'. Error message: $($PSItem.Exception.Message)"

        return $_TEMPFolder, $_RootFolder
        
        exit 1

    }

    try {

        if (-not (Test-Path -Path "${TargetPath}\${RootFolderName}\${CryptocurrencyPricesName}")) {
            $_CryptocurrencyPricesFolder = New-Item -Path "${TargetPath}\${RootFolderName}" -Name $CryptocurrencyPricesName -ItemType Directory -ErrorAction Stop
        }

        New-KEEnvVariable -envName "KE_CRYPTOCURRENCYPRICESFOLDER" -envValue "${TargetPath}\${RootFolderName}\${CryptocurrencyPricesName}"


    }
    catch {
        Write-Error "Can't create '${CryptocurrencyPricesName}' in '${TargetPath}\${RootFolderName}'. Error message: $($PSItem.Exception.Message)"

        return $_TEMPFolder, $_RootFolder, $_CryptocurrencyPricesFolder

        exit 1

    }    
    try {

        if (-not (Test-Path -Path "${TargetPath}\${RootFolderName}\${LogsName}")) {
            $_LogsFolder = New-Item -Path "${TargetPath}\${RootFolderName}" -Name $LogsName -ItemType Directory -ErrorAction Stop
        }

        New-KEEnvVariable -envName "KE_LOGSFOLDER" -envValue "${TargetPath}\${RootFolderName}\${LogsName}"


    }
    catch {
        Write-Error "Can't create '${LogsName}' in '${TargetPath}\${RootFolderName}'. Error message: $($PSItem.Exception.Message)"

        return $_TEMPFolder, $_RootFolder, $_CryptocurrencyPricesFolder, $_LogsFolder

        exit 1

    }    
    try {

        if (-not (Test-Path -Path "${TargetPath}\${RootFolderName}\${OtherName}")) {
            $_OtherFolder = New-Item -Path "${TargetPath}\${RootFolderName}" -Name $OtherName -ItemType Directory -ErrorAction Stop
        }

        New-KEEnvVariable -envName "KE_OTHERFOLDER" -envValue "${TargetPath}\${RootFolderName}\${OtherName}"


    }
    catch {
        Write-Error "Can't create '${OtherName}' in '${TargetPath}\${RootFolderName}'. Error message: $($PSItem.Exception.Message)"
 
        return $_TEMPFolder, $_RootFolder, $_CryptocurrencyPricesFolder, $_LogsFolder, $_OtherFolder

        exit 1

    }

    return $_TEMPFolder, $_RootFolder, $_CryptocurrencyPricesFolder, $_LogsFolder, $_OtherFolder

}