Clear-Host

$CodePath =  "C:\Program Files\Microsoft VS Code\Code.exe"

$baseFile = "Registry::HKEY_CURRENT_USER\Software\Classes\*\shell\VSCode"
$baseDir  = "Registry::HKEY_CURRENT_USER\Software\Classes\Directory\shell\VSCode"

# FILES
New-Item -Path $baseFile -Force | Out-Null
Set-ItemProperty -Path $baseFile -Name "(Default)" -Value "Open with Code"
Set-ItemProperty -Path $baseFile -Name "Icon" -Value $CodePath

New-Item -Path "$baseFile\command" -Force | Out-Null
Set-ItemProperty -Path "$baseFile\command" -Name "(Default)" -Value "`"$CodePath`" `"%1`""

# DIRECTORIES
New-Item -Path $baseDir -Force | Out-Null
Set-ItemProperty -Path $baseDir -Name "(Default)" -Value "Open with Code"
Set-ItemProperty -Path $baseDir -Name "Icon" -Value $CodePath

New-Item -Path "$baseDir\command" -Force | Out-Null
Set-ItemProperty -Path "$baseDir\command" -Name "(Default)" -Value "`"$CodePath`" `"%V`""

Write-Host "Done." -ForegroundColor Green