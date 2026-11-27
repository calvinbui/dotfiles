# Registers (or updates) a task that runs windows-show-tray-icons.ps1 every
# minute, so new tray icons appear on the taskbar instead of the ^ menu.
# Remove it with: Unregister-ScheduledTask -TaskName 'Show all tray icons'
$script = Join-Path $PSScriptRoot 'windows-show-tray-icons.ps1'

# conhost --headless stops a console window flashing up every minute
$action = New-ScheduledTaskAction -Execute 'conhost.exe' `
    -Argument "--headless powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File `"$script`""
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 1)
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries `
    -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Minutes 1)

Register-ScheduledTask -TaskName 'Show all tray icons' -Action $action -Trigger $trigger `
    -Settings $settings -Force | Out-Null
