
$origenImagen = "aramar.png"
$carpetaDestino = "C:\Wallpapers"
$nombreArchivo = (Get-Item $origenImagen).Name
$destinoImagen = Join-Path $carpetaDestino $nombreArchivo

if (-not (Test-Path $carpetaDestino)) {
    New-Item -Path $carpetaDestino -ItemType Directory | Out-Null
}
Copy-Item -Path $origenImagen -Destination $destinoImagen -Force

$code = @"
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    public static void SetWallpaper(string path) {
        SystemParametersInfo(20, 0, path, 0x01 | 0x02);
    }
}
"@
Add-Type -TypeDefinition $code
[Wallpaper]::SetWallpaper($destinoImagen)

winget install --id JanDeDobbeleer.OhMyPosh -e --accept-source-agreements --accept-package-agreements
$poshPath = "$env:LOCALAPPDATA\Programs\oh-my-posh\bin"
$env:Path += ";$poshPath"
oh-my-posh font install Meslo

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name Terminal-Icons -Repository PSGallery -Force

$comandoPosh = "oh-my-posh init pwsh --config 'fish' | Invoke-Expression"
$comandoIcon = "Import-Module Terminal-Icons"
if (-not (Test-Path $PROFILE)) {
    New-Item -Path $PROFILE -Type File -Force
}

$contenidoPerfil = Get-Content $PROFILE -ErrorAction SilentlyContinue
if ($contenidoPerfil -notcontains $comandoPosh) {
    Add-Content -Path $PROFILE -Value $comandoPosh
}
if ($contenidoPerfil -notcontains $comandoIcon) {
    Add-Content -Path $PROFILE -Value $comandoIcon
}

$wtPackages = Get-ChildItem -Path $env:LOCALAPPDATA\Packages -Filter Microsoft.WindowsTerminal_* -Recurse -ErrorAction SilentlyContinue
$settingsPath = Join-Path -Path $wtPackages.FullName -ChildPath "LocalState\settings.json" | Select-Object -First 1


if ($settingsPath -and (Test-Path $settingsPath)) {
    $backupPath = "$settingsPath.bak"
    Copy-Item -Path $settingsPath -Destination $backupPath -Force

    $newJsonContent = @'
{
    "$help": "https://aka.ms/terminal-documentation",
    "$schema": "https://aka.ms/terminal-profiles-schema",
    "actions": [],
    "copyFormatting": "none",
    "copyOnSelect": false,
    "defaultProfile": "{574e775e-4f2a-5b96-ac1e-a2962a402336}",
    "keybindings": 
    [
        {
            "id": "Terminal.CopyToClipboard",
            "keys": "ctrl+c"
        },
        {
            "id": "Terminal.PasteFromClipboard",
            "keys": "ctrl+v"
        },
        {
            "id": "Terminal.DuplicatePaneAuto",
            "keys": "alt+shift+d"
        }
    ],
        "newTabMenu": 
    [
        {
            "type": "remainingProfiles"
        }
    ],
    "profiles": 
    {
        "defaults": {},
        "list": 
        [
            {   
                "commandline": "%SystemRoot%\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",
                "guid": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
                "hidden": false,
                "name": "Windows PowerShell"
            },
            {
                "commandline": "%SystemRoot%\\System32\\cmd.exe",
                "guid": "{0caa0dad-35be-5f56-a8ff-afceeeaa6101}",
                "hidden": false,
                "name": "Command Prompt"
            },
            {
                "guid": "{b453ae62-4e3d-5e58-b989-0a998ec441b8}",
                "hidden": false,
                "name": "Azure Cloud Shell",
                "source": "Windows.Terminal.Azure"
            },
            {
                "guid": "{2ece5bfe-50ed-5f3a-ab87-5cd4baafed2b}",
                "hidden": false,
                "name": "Git Bash",
                "source": "Git"
            },
            {
                "colorScheme": "Ayu Dark",
                "font": 
                {
                    "face": "MesloLGL Nerd Font"
                },
                "guid": "{574e775e-4f2a-5b96-ac1e-a2962a402336}",
                "hidden": false,
                "name": "PowerShell",
                "source": "Windows.Terminal.PowershellCore"
            }
        ]
    },
    "schemes": 
    [
        {
            "name": "Ayu Dark",
            "background": "#0A0E14",
            "foreground": "#B3B1AD",
            "black": "#01060E",
            "blue": "#39BAE6",
            "brightBlack": "#686868",
            "brightBlue": "#39BAE6",
            "brightCyan": "#59F8ED",
            "brightGreen": "#C2D94C",
            "brightPurple": "#E1ACFF",
            "brightRed": "#F07178",
            "brightWhite": "#FFFFFF",
            "brightYellow": "#FFB454",
            "cyan": "#59F8ED",
            "green": "#C2D94C",
            "purple": "#E1ACFF",
            "red": "#F07178",
            "white": "#B3B1AD",
            "yellow": "#FFB454",
            "cursorColor": "#FFB454",
            "selectionBackground": "#253346"
        }
    ],
    "themes": []
}
'@

    Set-Content -Path $settingsPath -Value $newJsonContent -Encoding UTF8
} else {
    Write-Warning "No se pudo encontrar la ruta del archivo settings.json de Windows Terminal. Se omitió este paso."
}

npm install -g @google/gemini-cli
$npmPath = npm config get prefix
$env:Path += ";$npmPath"
Clear-Host
. $PROFILE
gemini