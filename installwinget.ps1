#Requires -RunAsAdministrator
# Install WinGet
# Based on this gist: https://gist.github.com/crutkas/6c2096eae387e544bd05cde246f23901
$hasPackageManager = Get-AppPackage -name 'Microsoft.DesktopAppInstaller'
if (!$hasPackageManager -or [version]$hasPackageManager.Version -lt [version]"1.10.0.0") {
    "Installing winget Dependencies"
    Add-AppxPackage -Path 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx'

    $releases_url = 'https://api.github.com/repos/microsoft/winget-cli/releases/latest'

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $releases = Invoke-RestMethod -uri $releases_url
    $latestRelease = $releases.assets | Where-Object { $_.browser_download_url.EndsWith('msixbundle') } | Select-Object -First 1

    "Installing winget from $($latestRelease.browser_download_url)"
    Add-AppxPackage -Path $latestRelease.browser_download_url
}
else {
    "winget already installed"
}

# Winget installs

Write-Host "Installing winget packages..."

# Programming packages

Write-Host "Enabling WSL"

wsl --install

$ProgrammingApps = @(
    @{name = "Microsoft.VisualStudioCode" },
    @{name = "Git.Git" },
    @{name = "Microsoft.WindowsTerminal"; source = "msstore" },
    @{name = "OpenJS.NodeJS.LTS" },
    @{name = "Docker.DockerDesktop" },
    @{name = "GitHub.cli" },
    @{name = "Microsoft.PowerToys" },
    @{name = "Python.Python.3" },
    @{name = "Postman.Postman" },
    @{name = "MongoDB.Shell" },
    @{name = "MongoDB.Compass.Community" },
    @{name = "Microsoft.VisualStudio.2022.Community" },
    @{name = "Microsoft.VisualStudio.2019.BuildTools" },
    # @{name = "JanDeDobbeleer.OhMyPosh" },
    # @{name = "Microsoft.dotnet" },
    @{name = "DevToys"; source = "msstore" }
)

$GamingApps = @(
    @{name = "Valve.Steam" },
    @{name = "Discord.Discord" },
    @{name = "Nvidia.GeForceExperience" },
    @{name = "EpicGames.EpicGamesLauncher" },
    @{name = "ElectronicArts.EADesktop" },
    @{name = "Ubisoft.Connect" }
)

$MiscellaneousApps = @(
    @{name = "Logitech.GHUB" },
    @{name = "CPUID.CPU-Z" },
    @{name = "OBSProject.OBSStudio" },
    @{name = "ProtonTechnologies.ProtonVPN" },
    @{name = "Spotify.Spotify" },
    @{name = "VideoLAN.VLC" },
    @{name = "WinDirStat.WinDirStat" },
    @{name = "RARLab.WinRAR" },
    @{name = "qBittorrent.qBittorrent" },
    @{name = "Adobe.Acrobat.Reader.64-bit" },
    @{name = "GIMP.GIMP" },
    @{name = "Rufus.Rufus" }
)

function InstallPackages {
    param (
        [Parameter(Mandatory)]
        [System.Object[]]$apps
    )
    
    Foreach ($app in $apps) {
        # check if the app is already installed
        $listApp = winget list --exact -q $app.name
        if (![String]::Join("", $listApp).Contains($app.name)) {
            Write-host "Installing:" $app.name
            if ($null -ne $app.source) {
                winget install --exact --silent $app.name --source $app.source --accept-source-agreements
            }
            else {
                winget install --exact --silent $app.name 
            }
        }
        else {
            Write-host "Skipping Install of " $app.name
        }
    }
}

Write-Host "Installing Programming Apps"
InstallPackages($ProgrammingApps)

Write-Host "Installing Gaming Apps"
InstallPackages($GamingApps)

Write-Host "Installing Miscellaneous Apps"
InstallPackages($MiscellaneousApps)

Write-Host "Finished winget installs"