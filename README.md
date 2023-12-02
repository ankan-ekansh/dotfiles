# dotfiles

## Prerequisites

- Make sure PowerShell(cross-platform version) is installed. [PowerShell docs](https://aka.ms/powershell)
- Git for cloning the repo. Manually install from [Git-Scm](https://git-scm.com/downloads). Can run ```winget install -e --id Git.Git``` if on Windows with winget already installed. On Linux or MacOS use respective package manager. eg. ```sudo apt install git```
- Windows Terminal for fonts and theming in config.ps1

## Steps

- Go to the home directory and clone the repo. Then cd into the dotfiles directory
    ````bash
    cd ~
    git clone 'https://github.com/ankan-ekansh/dotfiles.git'
    cd dotfiles
    ````
- Open an elevated PowerShell prompt from Windows Terminal. Run installwinget.ps1 first then config.ps1
    ```pwsh
    ./installwinget.ps1
    ./config.ps1
    ```
- After completion, open Windows terminal settings and change the font to 'CaskaydiaCove NF' for PowerShell profile.

## TODO:
- [ ] Make the setup more OS agnostic, include bash and/or python scripts
- [ ] Steps for MacOS

## Known Issues:
- config.ps1 might give an error related to administrator rights on Windows. Disabling ransonware protection before running the script can help fixing this. Needs investigation.
- installwinget.ps1 might get stuck after
    ```pwsh
    wsl --install
    ```
  Restarting the script is only known workaround as of now.
- Some packages fail with various error codes, removed the entries for now.
- Fonts not getting installed via config.ps1 script. Might move to Prerequisites or add a manual step for this.