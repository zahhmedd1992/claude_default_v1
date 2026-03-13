# Kill lingering MSIX Claude processes
$msixPath = "C:\Program Files\WindowsApps"
$msixProcs = Get-Process claude -ErrorAction SilentlyContinue | Where-Object { $_.MainModule.FileName -like "$msixPath*" }
foreach ($p in $msixProcs) {
    Write-Host "Killing MSIX process PID $($p.Id)"
    Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue
}

# Fix the protocol handler to point to traditional install
$correctPath = '"C:\Users\zacha\AppData\Local\AnthropicClaude\app-1.1.5368\claude.exe" "%1"'
Set-ItemProperty -Path "HKCU:\SOFTWARE\Classes\claude\shell\open\command" -Name "(default)" -Value $correctPath -Force

Write-Host "Registry fixed. New value:"
Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Classes\claude\shell\open\command" -Name "(default)"
