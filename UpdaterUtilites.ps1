param (
    [String]$silentParam
) 
$silent = $null
if ($silentParam -match "1") {
    $silent = $true
} else {
    $silent = $false
}
#An r5 Reloaded update script
#Created by TheInatorInator Discord:Theinatorinator#4434 Github:https://github.com/Theinatorinator

<#
.SYNOPSIS
Gets the new SDK version, and extracts it to temp directory

.DESCRIPTION
Downloadeds an extracts the SDK file from https://github.com/Mauler125/r5sdk/

.PARAMETER shouldDeleteDepotZip
[BOOLEAN}If true it will save the depot zip, leaving only the extracted depot. Defaults to false

.notes 
Technically, we could reuse this with some tweaking for both the SDK and the aimtrainer, but im to lazy to do that right now. Polymorphsim baby
#>
function DownloadAndExtractDepot {
    param([bool]$shouldSaveDepotZip)
    #default params if not included
    if ($shouldSaveDepotZip=$null) {
        $shouldSaveDepotZip=$false
    }
    #temp directory
    If(!(test-path -PathType container "./temp"))
    {
        New-Item -ItemType Directory -Path "./temp"
    }  
    #check if path created sucsesfully
    If(!(test-path -PathType container "./temp"))
    {
        throw "temp directory missing"
    } 
    #check and remove previous depots
    If(test-path -PathType container "./temp/depot")
    {
        remove-item -path "./temp/depot" -Force -Recurse -ErrorAction SilentlyContinue
    }  
    If(test-path -PathType leaf "./temp/depot.zip")
    {
        remove-item -path "./temp/depot.zip" -Force -Recurse -ErrorAction SilentlyContinue
    } 
    #download latest depot
    curl.exe -L "https://github.com/Mauler125/r5sdk/releases/latest/download/depot.zip" --output "./temp/depot.zip"
    #check download
    If(!(test-path -PathType leaf "./temp/depot.zip"))
    {
        throw "Download Failed"
    } 
    #extract depot   
    Expand-Archive "./temp/depot.zip" -DestinationPath "./temp/depot"
    #delete depot zip if requested
    if (!$shouldSaveDepotZip) {
        remove-item -path "./temp/depot.zip" -Force -Recurse -ErrorAction SilentlyContinue
    }
}
<#
.SYNOPSIS
Installs SDK

.DESCRIPTION
copys SDK into game directory from temp directory

.PARAMETER shouldDeleteDepotFolder
[BOOLEAN], if true then will save depot folder, not depto zip in temp. Defaults to false
#>
function CopyDepotFiles {
    param([bool]$shouldSaveDepotFolder)
    #default params if not included
    if ($shouldSaveDepotFolder=$null) {
        $shouldSaveDepotFolder=$false
    }
    #check for depot exsistince
    If(!(test-path -PathType container "./temp/depot"))
    {
        throw "Missing Depot!"
    }  
    #copy files
    Copy-Item -Force -Recurse -Verbose "./temp/depot/*" -Destination "./"
    #delete depot folder if requested
    if (!$shouldSaveDepotFolder) {
        remove-item -path "./temp/depot" -Force -Recurse -ErrorAction SilentlyContinue
    }
}

function Main {
    param([bool]$silent)
    $saveZips = $false;
    $saveFolders = $false;
    if ($silent) {
    DownloadAndExtractDepot $saveZips
    CopyDepotFiles
    Write-Host "OPERATION COMPLETE!" -ForegroundColor Green -BackgroundColor Black
    exit 0
    }
    $reply = $null
    $reply = Read-Host -Prompt "Do you want to save the zip files?[y/n]"
    if ( $reply -match "[yY]" ) { 
        $saveZips = $true
    }
    DownloadAndExtractDepot $saveZips
    CopyDepotFiles $saveFolders
    Write-Host "OPERATION COMPLETE!" -ForegroundColor Green -BackgroundColor Black
}

Main $silent
