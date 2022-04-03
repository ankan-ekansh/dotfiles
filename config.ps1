#Requires -RunAsAdministrator

if ($IsWindows) {
    Write-Host "Installing Fonts"
    Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip" -OutFile "./CascadiaCode.zip"
    mkdir tmp
    Expand-Archive -LiteralPath ".\CascadiaCode.zip" -DestinationPath ".\tmp"
    $fonts = Get-ChildItem ".\tmp"
    foreach ($font in $fonts) {
        $fontFile = $font.Name
        $destPath = Join-Path -Path "C:\Windows\Fonts" -ChildPath $fontFile
        $sourcePath = Join-Path -Path ".\tmp" -ChildPath $fontFile
        if (!(Test-Path -Path $destPath -PathType Leaf)) {
            Write-Host "$fontFile not installed, installing"
            Copy-Item $sourcePath -Destination $destPath
        }
        else {
            Write-Host "$fontFile already installed, skipping"
        }
    }

    New-Item -ItemType SymbolicLink -Path "~\.gitconfig" -Target "dotfiles\.gitconfig" -Force

    New-Item -ItemType SymbolicLink -Path "~\OneDrive\Documents\PowerShell" -Target "..\..\dotfiles\PowerShell" -Force

    Write-Host "Cleaning up stuff"

    Remove-Item CascadiaCode.zip
    Remove-Item tmp -Recurse -Force
}

if ($IsLinux) {
    Write-Host "Installing Fonts"

    bash -c "wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip"
    mkdir ~/.fonts
    Expand-Archive -LiteralPath "CascadiaCode.zip" -DestinationPath "~/.fonts" -Force

    New-Item -ItemType SymbolicLink -Path "~/.config/powershell" -Target "../dotfiles/PowerShell" -Force

    New-Item -ItemType SymbolicLink -Path "~/.gitconfig" -Target "dotfiles/.gitconfig" -Force

    Write-Host "Cleaning up stuff"

    Remove-Item CascadiaCode.zip
}

if ($IsMacOS) {
    # TODO: Add config steps for MacOS
    Write-Host "MacOS steps yet to be added"
}

Write-Host "Checking for PowerShell module dependencies"

if ($host.Name -eq 'ConsoleHost') {
    if (!(Get-Module -ListAvailable -Name PSReadLine)) {
        Write-Host "PSReadLine module not found, installing"
        Install-Module -Name PSReadLine -AllowPrerelease -Force -Scope CurrentUser
    }
}

if (!(Get-Module -ListAvailable -Name Terminal-Icons)) {
    Write-Host "Terminal-Icons module not found, installing"
    Install-Module -Name Terminal-Icons -Force -Scope CurrentUser
}

if (!(Get-Module -ListAvailable -Name oh-my-posh)) {
    Write-Host "oh-my-posh module not found, installing"
    Install-Module -Name oh-my-posh -Force -Scope CurrentUser
}

Write-Host "Completed configuration settings"