# Define the name of the JSON file
$jsonFileName = "EnvArenaDoc12.json"

# Combine the script directory path with the JSON file name to get the full path
$jsonFilePath = Join-Path $PSScriptRoot $jsonFileName

# Read the JSON file content
$jsonContent = Get-Content $jsonFilePath -Raw | ConvertFrom-Json

# Define the path to the system-level environment variables in the registry
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"

# Check if the script is running with administrative privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to run this script as Administrator to modify system environment variables!"
    Exit
}

# Check if the registry key exists, if not, create it
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force
}

# Iterate over each element in the JSON array and set the registry value
foreach ($element in $jsonContent) {
    $name = $element.name
    $value = $element.value

    # Set the registry value
    Set-ItemProperty -Path $registryPath -Name $name -Value $value
    Write-Output "$($name) $($value)"
}

Write-Output "System-wide registry values have been set successfully!"
