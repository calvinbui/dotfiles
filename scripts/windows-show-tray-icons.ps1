# Shows every tray icon on the taskbar, including ones new apps add later.
# Run by the "Show all tray icons" task; see windows-install-tray-icons-task.ps1.
$icons = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Control Panel\NotifyIconSettings')
if (-not $icons) { exit }

foreach ($name in $icons.GetSubKeyNames()) {
    $icon = $icons.OpenSubKey($name)
    $promoted = $icon.GetValue('IsPromoted')
    $icon.Close()
    if ($promoted -ne 1) {
        $icon = $icons.OpenSubKey($name, $true)
        $icon.SetValue('IsPromoted', 1, [Microsoft.Win32.RegistryValueKind]::DWord)
        $icon.Close()
    }
}
$icons.Close()
