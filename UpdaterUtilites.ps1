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

function DownloadAndExtractAimTrainer {
    param([bool]$shouldSaveAimTrainerZip)
    #default params if not included
    if ($shouldSaveAimTrainerZip=$null) {
        $shouldSaveAimTrainerZip=$false
    }
    If(!(test-path -PathType container "./temp"))
    {
        New-Item -ItemType Directory -Path "./temp"
    }  
    #check if path created sucsesfully
    If(!(test-path -PathType container "./temp"))
    {
        throw "temp directory missing"
    } 
    #check and remove previous aimreqs
    If(test-path -PathType container "./temp/aimreq")
    {
        remove-item -path "./temp/aimreq" -Force -Recurse -ErrorAction SilentlyContinue
    }  
    If(test-path -PathType leaf "./temp/aimreq.zip")
    {
        remove-item -path "./temp/aimreq.zip" -Force -Recurse -ErrorAction SilentlyContinue
    } 
    #check and remove previous AimTrainerScripts
    If(test-path -PathType container "./temp/r5_aimtrainer-r5_aimtrainer")
    {
        remove-item -path "./temp/r5_aimtrainer-r5_aimtrainer" -Force -Recurse -ErrorAction SilentlyContinue
    }  
    If(test-path -PathType leaf "./temp/aimTrainerScripts.zip")
    {
         remove-item -path "./temp/aimTrainerScripts.zip" -Force -Recurse -ErrorAction SilentlyContinue
    } 
    #download latest aim trainer required files
    curl.exe -L "https://github.com/ColombianGuy/r5_aimtrainer/releases/latest/download/AimTrainerRequiredFiles.zip" --output "./temp/aimreq.zip"
    #download latest aim trainer Scripts
    curl.exe -L "https://github.com/ColombianGuy/r5_aimtrainer/archive/refs/heads/r5_aimtrainer.zip" --output "./temp/aimTrainerScripts.zip"
    #check downloads
    If(!(test-path -PathType leaf "./temp/aimreq.zip"))
    {
        throw "Download Failed"
    } 
    If(!(test-path -PathType leaf "./temp/aimTrainerScripts.zip"))
    {
        throw "Download Failed"
    } 
    #extract AimTrainerFiles   
    Expand-Archive "./temp/aimreq.zip" -DestinationPath "./temp/aimreq"
    Expand-Archive "./temp/aimTrainerScripts.zip" -DestinationPath "./temp/"
    #delete depot zip if requested
    if (!$shouldSaveAimTrainerZip) {
        remove-item -path "./temp/aimreq.zip" -Force -Recurse -ErrorAction SilentlyContinue
        remove-item -path "./temp/aimTrainerScripts.zip" -Force -Recurse -ErrorAction SilentlyContinue
    }
    
}

function CopyAimTrainerFiles {
    param([bool]$shouldSaveAimTrainerFolders)
    #default params if not included
    if ($shouldSaveAimTrainerFolders=$null) {
        $shouldSaveAimTrainerFolders=$false
    }
    #check for depot exsistince
    If(!(test-path -PathType container "./temp/aimreq"))
    {
        throw "Missing aimreq files!"
    }  
    If(!(test-path -PathType container "./temp/r5_aimtrainer-r5_aimtrainer"))
    {
        throw "Missing AimTrainerScripts!"
    } 
    #copy files
    Copy-Item -Force -Recurse -Verbose "./temp/aimreq/*" -Destination "./"
    Copy-Item -Force -Recurse -Verbose "./temp/r5_aimtrainer-r5_aimtrainer/*" -Destination "./platform/scripts/"
    #delete depot folder if requested
    if (!$shouldSaveAimTrainerFolders) {
        remove-item -path "./temp/aimreq" -Force -Recurse -ErrorAction SilentlyContinue
        remove-item -path "./temp/r5_aimtrainer-r5_aimtrainer" -Force -Recurse -ErrorAction SilentlyContinue
    }
    
}

function Main {
    $silent = false
    $saveZips = $false;
    $saveFolders = $false;
    $flowState = $false;
    $sdk = $false;
    if ($silent) {
        DownloadAndExtractDepot $saveZips
        DownloadAndExtractAimTrainer
        CopyDepotFiles
        CopyAimTrainerFiles
        Write-Host "OPERATION COMPLETE!" -ForegroundColor Green -BackgroundColor Black
        exit 0
    }
    $reply = Read-Host -Prompt "Press S for simple update, press D to enter advanced mode ?[S/D]"
    if ( $reply -notmatch "[sS]" ) { 
        $reply = $null
        $reply = Read-Host -Prompt "Do you want to save the zip files?[y/n]"
        if ( $reply -match "[yY]" ) { 
            $saveZips = $true
        }
        $reply = $null
        $reply = Read-Host -Prompt "Do you want to save the extracted zip files?[y/n]"
        if ( $reply -match "[yY]" ) { 
            $saveFolders = $true
        }
    }
    $reply = $null
    $reply = Read-Host -Prompt "Do you want to Update/Install The Flowstate Aim trainer?[y/n]"
    if ( $reply -match "[yY]" ) { 
        $flowState = $true
    }
    $reply = $null
    $reply = Read-Host -Prompt "Do you want to Update/Install The r5 SDK?[y/n]"
    if ( $reply -match "[yY]" ) { 
        $sdk = $true
    }
    if ($sdk) {
        DownloadAndExtractDepot $saveZips
    }
    if ($flowState) {
        DownloadAndExtractAimTrainer $saveZips
    }
    if ($sdk) {
        CopyDepotFiles $saveFolders
    }
    if ($flowState) {
        CopyAimTrainerFiles $saveFolders  
    }
    Write-Host "OPERATION COMPLETE!" -ForegroundColor Green -BackgroundColor Black
}

Main