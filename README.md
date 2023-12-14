# PowerShell Setup Laptop

[![license](https://img.shields.io/github/license/ptavares/powershell-setup-laptop)](./LICENSE)

## Description 

Simple script to setup my Windows Terminal.

It will install : 

1. [Scoop](https://github.com/ScoopInstaller/Scoop) : a command line installer
2. Scoop package:
    - [windows-terminal](https://github.com/microsoft/terminal) (optional)
    - [pwsh](https://github.com/PowerShell/PowerShell) (optional)
    - [curl](https://curl.se/)
    - [jq](https://jqlang.github.io/jq/)
    - [neovim](https://neovim.io/)
3. Install [Z](https://github.com/badmotorfinger/z) (make navigation in PowerShell extremely easy)
4. Install [Terminal Icons](https://github.com/devblackops/Terminal-Icons) (It gives specific Icons to windows based on file type)"
5. Install [PSReadLine](https://www.powershellgallery.com/packages/PSReadLine/) (add autocompletion to PowerShell based on previous commands)
6. Install [Fzf](https://www.powershellgallery.com/packages/PSFzf) (Fuzzy finder and its PowerShell Module)
7. Install [oh my posh](https://ohmyposh.dev/) and themes
8. Install my personal oh my posh [custom theme](ptavares.omp.json) inspired by [jandedobbeleer](https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/jandedobbeleer.omp.json)
9. Install [Nerd Fonts](https://www.nerdfonts.com/font-downloads)
    - CascadiaCode (optional)
    - SourceCodePro (optional)
10. Configure personal PowerShell Settings with all this this tools

## ⚙️ Installation

### Prerequisite

You need [Git](https://github.com/git-guides/install-git) command line

### Clone and run

```powershell
# Clone this repository
git clone https://github.com/ptavares/powershell-setup-terminal.git

```

## 🛂 Usage

```powershell

# Go inside previsouly cloned repository
cd powershell-setup-terminal

# Just launch install script !
.\setup.ps1
```

## 📙 License

[MIT](./LICENCE)