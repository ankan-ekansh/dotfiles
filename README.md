# dotfiles

## Prerequisites

- Make sure PowerShell(cross-platform version) is installed. [PowerShell docs](https://aka.ms/powershell)
- Git for cloning the repo. Can run ```winget install -e --id Git.Git``` if on Windows with winget installed. On Linux or MacOS use respective package manager. eg. ```sudo apt install git```

## Steps

- Go to the home directory and clone the repo. Then cd into the dotfiles directory
    ````bash
    cd ~
    git clone 'https://github.com/ankan-ekansh/dotfiles.git'
    cd dotfiles
    ````
- Run installwinget.ps1 first then config.ps1
    ```pwsh
    ./installwinget.ps1
    ./config.ps1
    ```

## TODO:
- [ ] Move hardcoded PowerShell modules to a separate file
- [ ] Make the setup more OS agnostic, include bash and/or python scripts
- [ ] Steps for MacOS