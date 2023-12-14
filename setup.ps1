function Write-ToProfile {
    param (
        [Parameter(Mandatory)]
        [bool] $Append,
        [Parameter(Mandatory)]
        [string] $Message
    )

    if ($Append) {
        $Message | Out-File $PROFILE -Append 
    }
    else {
        $Message | Out-File $PROFILE
    }
}

function Test-CommandExists {
    param (
        [Parameter(Mandatory)]
        [string] $Command
    )
    
    $oldPreference = $ErrorActionPreference

    $ErrorActionPreference = ‘stop’

    try { if (Get-Command $Command) { return $true } }

    Catch { return $false }

    Finally { $ErrorActionPreference = $oldPreference }
}

function Update-ModuleWin {
    param(
        [Parameter(Mandatory)]
        [string] $moduleName
    )
    # Check if the module is installed
    if (Get-Module -ListAvailable -Name $moduleName) {
        Write-Warning "Module '$moduleName' is already installed. Updating..."
        Update-Module -Name $moduleName -Force
        return $true
    }
    else {
        return $false
    }
}

function Update-or-Install-ScoopPackage {
    param (
        [Parameter(Mandatory)]
        [string] $PackageName
    )
    if ( (scoop list $PackageName | findstr $PackageName | Measure-Object -Line).Lines -ne 1 ) {
        scoop install $PackageName    
    }
    else {
        Write-Warning "Package $PackageName already exist, trying to update instead..."
        scoop update $PackageName
    }
}

Write-Output "# -------------------------------------------------------- #"
Write-Output "__      _                   __             _               "
Write-Output "/ _\ ___| |_ _   _ _ __     / /  __ _ _ __ | |_ ___  _ __  "
Write-Output "\ \ / _ \ __| | | | '_ \   / /  / _` | '_ \| __/ _ \| '_ \ "
Write-Output "_\ \  __/ |_| |_| | |_) | / /__| (_| | |_) | || (_) | |_) |"
Write-Output "\__/\___|\__|\__,_| .__/  \____/\__,_| .__/ \__\___/| .__/ "
Write-Output "                  |_|                |_|            |_|    "
Write-Output "# -------------------------------------------------------- #"


Write-Output
Write-Output "##################################################"
Write-Output " -> Install Scoop, a command line installer"
Write-Output "##################################################"
if (Test-CommandExists scoop) {
    Write-Warning "Scoop already install, trying to update"
    scoop update
}
else {
    Invoke-WebRequest -useb get.scoop.sh | Invoke-Expression
    scoop bucket add extras
}

Write-Output
Write-Output "##################################################"
Write-Output " -> Install (Optional) windows package using scoop"
Write-Output "##################################################"
$response = Read-Host "Do you want to install 'Windows Terminal' for $env:USERNAME ? (Y/N)"
if ($response -eq 'Y' -or $response -eq 'y') {
    Update-or-Install-ScoopPackage windows-terminal
}
$response = Read-Host "Do you want to install 'Powershell 7' for $env:USERNAME ? (Y/N)"
if ($response -eq 'Y' -or $response -eq 'y') {
    scoop install pwsh
    'C:\Users\M62891\scoop\apps\pwsh\current\install-explorer-context.reg'
    'C:\Users\M62891\scoop\apps\pwsh\current\install-file-context.reg'
}

Write-Output
Write-Output "##################################################"
Write-Output " -> Install local package using scoop"
Write-Output "##################################################"
Write-Output "-----> curl (the client url tools)"
Update-or-Install-ScoopPackage curl
Write-Output
Write-Output "-----> jq"
Update-or-Install-ScoopPackage jq
Write-Output
Write-Output "-----> Neovim (a new interesting factor of vim)"
Update-or-Install-ScoopPackage neovim 

Write-Output "-----> Install vim-plug for Neovim"
mkdir ~\AppData\Local\nvim\
mkdir ~\AppData\Local\nvim\autoload
$uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
(New-Object Net.WebClient).DownloadFile(
  $uri,
  $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
    "~\AppData\Local\nvim\autoload\plug.vim"
  )
)
Copy-Item .\config\init.vim -Destination ~\AppData\Local\nvim\

Write-Output "Don't forget to call ':PlugInstall' on first Vim launch"

Write-Output
Write-Output "##################################################"
Write-Output " -> Install Z (make navigation in PowerShell extremely easy)"
Write-Output "##################################################"
if ( -not (Update-ModuleWin z) ) {
    Install-Module -Name z -Force
}

Write-Output
Write-Output "##################################################"
Write-Output " -> Install terminal Icons (It gives specific Icons to windows based on file type)"
Write-Output "##################################################"
if ( -not (Update-ModuleWin Terminal-Icons) ) {
    Install-Module -Name Terminal-Icons -Repository PSGallery
}

Write-Output
Write-Output "##################################################"
Write-Output " -> Install PSReadLine (add autocompletion to PowerShell based on previous commands)"
Write-Output "##################################################"
if ( -not (Update-ModuleWin PSReadLine) ) {
    Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck
}

Write-Output
Write-Output "##################################################"
Write-Output " -> Install Fzf (Fuzzy finder and its PowerShell Module)"
Write-Output "##################################################"
Update-or-Install-ScoopPackage fzf
if ( -not (Update-ModuleWin PSFzf) ) {
    Install-Module -Name PSFzf -Scope CurrentUser -Force
}

Write-Output
Write-Output "##################################################"
Write-Output " -> Install oh my posh and themes"
Write-Output "##################################################"
winget install JanDeDobbeleer.OhMyPosh -s winget

Write-Output
Write-Output "##################################################"
Write-Output " -> Install oh my posh custom themes"
Write-Output "##################################################"
Copy-Item -Path .\config\ptavares.omp.json -Destination $env:POSH_THEMES_PATH

Write-Output
Write-Output "##################################################"
Write-Output " -> Install Nerd Fonts"
Write-Output "##################################################"
$response = Read-Host "Do you want to install the font 'CascadiaCode' ? (Y/N)"
if ($response -eq 'Y' -or $response -eq 'y') {
    oh-my-posh font install --user CascadiaCode
}
$response = Read-Host "Do you want to install the font 'SourceCodePro' ? (Y/N)"
if ($response -eq 'Y' -or $response -eq 'y') {
    oh-my-posh font install --user SourceCodePro
}

Write-Output
Write-Output "##################################################"
Write-Output " -> Install terraform-tools"
Write-Output "##################################################"
if ( -not (Update-ModuleWin terraform-tools) ) {
    Install-Module -Name terraform-tools -Repository PSGallery
}

Write-Output
Write-Output "##################################################"
Write-Output " -> Creating PowerShell profile if it already does not exist"
Write-Output "##################################################"
New-Item -Path $profile -Type File -Force

Write-Output
Write-Output "##################################################"
Write-Output " -> Configuring PowerShell profile..."
Write-Output "##################################################"

$profileConfig = @"
# Imports the terminal Icons into curernt Instance of PowerShell
Import-Module -Name Terminal-Icons

# Initialize Oh My Posh with the theme which we chosen
oh-my-posh init pwsh --config "`$env:POSH_THEMES_PATH\ptavares.omp.json" | Invoke-Expression

# Set some useful Alias to shorten typing and save some key stroke
Set-Alias vim nvim
Set-Alias vi nvim
Set-Alias ll ls 
function la { ls -Force }
function ls-lrt {ls | Sort-Object LastWriteTime -Descending }
Set-Alias grep findstr

# Set Some Option for PSReadLine to show the history of our typed commands
Set-PSReadLineOption -PredictionSource History 
Set-PSReadLineOption -PredictionViewStyle ListView 
Set-PSReadLineOption -EditMode Windows 

#Fzf (Import the fuzzy finder and set a shortcut key to begin searching)
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# Utility Command that tells you where the absolute path of commandlets are 
function which (`$command) { 
 Get-Command -Name `$command -ErrorAction SilentlyContinue | 
 Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue 
}
"@

Write-ToProfile $true $profileConfig
