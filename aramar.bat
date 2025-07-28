@echo off

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set "params=%*"
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B
:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

winget install --id Google.Chrome -e --accept-source-agreements --accept-package-agreements
winget install --id Google.GoogleDrive -e --accept-source-agreements --accept-package-agreements
winget install --id Python.Python.3.13 -e --accept-source-agreements --accept-package-agreements
winget install --id Microsoft.PowerShell -e --accept-source-agreements --accept-package-agreements
winget install --id Git.Git -e --accept-source-agreements --accept-package-agreements
winget install --id OpenJS.NodeJS -e --accept-source-agreements --accept-package-agreements
winget install --id Microsoft.VisualStudioCode -e --accept-source-agreements --accept-package-agreements
winget install --id Docker.DockerDesktop -e --accept-source-agreements --accept-package-agreements
winget install --id Oracle.JavaRuntimeEnvironment -e --accept-source-agreements --accept-package-agreements
winget install --id Microsoft.Office -e --accept-source-agreements --accept-package-agreements
winget install --id Adobe.CreativeCloud -e --accept-source-agreements --accept-package-agreements
winget install --id Adobe.Acrobat.Pro -e --accept-source-agreements --accept-package-agreements
winget install --id Oracle.VirtualBox -e --accept-source-agreements --accept-package-agreements

powershell.exe -Command "Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force"
start pwsh.exe -File "aramar.ps1"