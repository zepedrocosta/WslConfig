Clear-Host

Remove-Item -Path "Registry::HKEY_CURRENT_USER\Software\Classes\*\shell\VSCode" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "Registry::HKEY_CURRENT_USER\Software\Classes\Directory\shell\VSCode" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Removed." -ForegroundColor Green
