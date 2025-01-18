# This script is based on work by drmohundro
# Original source: https://github.com/drmohundro/dotfiles/blob/main/install.ps1
# License: MIT (https://opensource.org/licenses/MIT)
#
# Modifications made by Jake Richhart (January 2025):
# - Removed macos as I don't use it
# - Added ability to skip_processing on a per-os basis

param (
    [switch]
    $whatIf
)

$config = Get-Content ./config.json | ConvertFrom-Json -AsHashtable

if ($IsWindows) {
    $documentsPath = [Environment]::GetFolderPath('MyDocuments')
    $env:MYDOCUMENTS = $documentsPath
}

function log($msg) {
    Write-Host "💡 $msg"
}
function Resolve-PathSafe($path) {
    $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
}

function defaultPath($pathName) {
    [PSObject] @{
        Link   = Resolve-PathSafe "~/.$($pathName)"
        Target = Resolve-PathSafe $pathName
    }
}

function checkConfig($os, $pathName) {
    if ($config[$os].length -ge 0) {
        if ($null -ne $config[$os][$pathName]) {
            $config[$os][$pathName] | Foreach-Object {
                [PSObject] @{
                    Link   = Resolve-PathSafe ([System.Environment]::ExpandEnvironmentVariables($_))
                    Target = Resolve-PathSafe $pathName
                }
            }
        }
    }
    else {
        defaultPath $pathName
    }
}

function determinePath($path) {
    log "Checking $path..."

    $pathName = $path.Name

    if ($null -ne $config['windows'][$pathName] -and $IsWindows) {
        checkConfig -os 'windows' -pathName $pathName
    }
    elseif ($null -ne $config['linux'][$pathName] -and $IsLinux) {
        log "Checking Config"
        checkConfig -os 'linux' -pathName $pathName
    }
    else {
        defaultPath $pathName
    }
}

function linkFile($map) {
    if (Test-Path $map.Link) {
        log "Skipping $($map.Link) as it already exists"
        return
    }

    # validate that $map.Target's directory exists and create it if it doesn't
    $targetDirectory = Split-Path $map.Target
    if (-not (Test-Path $targetDirectory)) {
        if ($whatIf) {
            log "Creating directory $targetDirectory"
        }
        else {
            New-Item -ItemType Directory -Path $targetDirectory
        }
    }

    if ($whatIf) {
        log "Linking $($map.Link) to $($map.Target)"
    }
    else {
        if ((Get-Item $map.Target) -is [System.IO.DirectoryInfo] -and $IsWindows) {
            New-Item -Path $_.Link -ItemType Junction -Value $_.Target
        }
        else {
            New-Item -Path $_.Link -ItemType SymbolicLink -Value $_.Target
        }
    }
}

function main {
    Get-ChildItem | ForEach-Object {
        $file = $_

        if ($config.skip_processing -contains $file.Name) { return }
        if ($file.Name.StartsWith('.')) { return }
        if ($IsWindows -and $config.windows.skip_processing -contains $file.Name) { return }
        if ($IsLinux -and $config.linux.skip_processing -contains $file.Name) { return }

        determinePath $file | ForEach-Object {
            if ((Test-Path $_.Target) -and $null -ne (Get-Item $file).LinkType) {
                return
            }
            
            linkFile $_
        }
    }
}

try {
    Push-Location $PSScriptRoot
    main
}
finally {
    Pop-Location
}