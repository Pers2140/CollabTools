
# Check if running as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run this script as an administrator." -ForegroundColor Red
    Exit 1
}

# Install WSL2
Write-Host "Installing WSL2..."
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Download and install WSL2 Linux kernel update package
Write-Host "Downloading and installing WSL2 Linux kernel update package..."
$kernelUrl = "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
$kernelPath = "$env:TEMP\wsl_update_x64.msi"
Invoke-WebRequest $kernelUrl -OutFile $kernelPath
Start-Process -FilePath $kernelPath -ArgumentList "/quiet" -Wait
Remove-Item -Path $kernelPath -Force

# Set WSL2 as the default WSL version
Write-Host "Setting WSL2 as the default WSL version..."
wsl.exe --set-version Ubuntu-20.04 2

# Install Docker Desktop
Write-Host "Installing Docker Desktop..."
$dockerUrl = "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"
$dockerPath = "$env:TEMP\Docker Desktop Installer.exe"
Invoke-WebRequest $dockerUrl -OutFile $dockerPath
Start-Process -FilePath $dockerPath -ArgumentList "/quiet" -Wait
Remove-Item -Path $dockerPath -Force

# Start Docker service
Write-Host "Starting Docker service..."
Start-Service Docker

Write-Host "WSL2 and Docker installation completed successfully."
