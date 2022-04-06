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

    New-Item -ItemType SymbolicLink -Path "~\Documents\PowerShell" -Target "..\dotfiles\PowerShell" -Force

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

$modules = Get-Content -Path './ps-modules.json' | ConvertFrom-Json

foreach ($module in $modules) {
    $name = $module.name
    $flags = $module.flags
    if (Get-InstalledModule -Name $name -ErrorAction:SilentlyContinue) {
        Write-Host "Module $name exists, skipping install"
    }
    else {
        Write-Host "Module $name does not exist, installing..."
        if ($flags) {
            Install-Module -Name $name $flags -Force -Scope CurrentUser
        }
        else {
            Install-Module -Name $name -Force -Scope CurrentUser
        }
    }
}

Write-Host "Checking for PowerShell scripts"

$scripts = Get-Content -Path './ps-scripts.json' | ConvertFrom-Json

foreach ($script in $scripts) {
    $name = $script.name
    if (Get-InstalledScript -Name $name -ErrorAction:SilentlyContinue) {
        Write-Host "Script $name exists, skipping install"
    }
    else {
        Write-Host "Script $name does not exist, installing..."
        Install-Script -Name $name -Force
    }
}

Write-Host "Completed configuration settings"