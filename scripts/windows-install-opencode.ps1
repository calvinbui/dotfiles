# Installs the opencode and windows packages (OpenCode's AGENTS.md and Windows
# opencode.jsonc) into ~, the way stow-profile.sh does on Linux and macOS.
# Dry run by default; pass -Apply to change files. Files are symlinked into this
# checkout when Windows allows it (Developer Mode or an elevated shell) and
# copied otherwise; rerun after pulling to refresh copies. Anything it replaces
# is first renamed to NAME.bak-TIMESTAMP. It never touches secrets\.
param(
    [switch]$Apply,
    [string]$Target = $HOME
)
$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot
$packages = 'opencode', 'windows'
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'

# mklink, unlike Windows PowerShell's New-Item, can use Developer Mode.
function New-Symlink($path, $source) {
    cmd /c mklink "$path" "$source" '>nul' '2>&1'
    return $LASTEXITCODE -eq 0
}

$probe = Join-Path ([IO.Path]::GetTempPath()) "dotfiles-symlink-probe-$PID"
$useLinks = New-Symlink $probe $PSCommandPath
Remove-Item -LiteralPath $probe -Force -ErrorAction SilentlyContinue
if ($useLinks) {
    Write-Output 'Symlinks are available: linking files into this checkout.'
} else {
    Write-Output 'Symlinks need Developer Mode or admin rights: copying files instead.'
}
if (-not $Apply) { Write-Output 'Dry run; pass -Apply to make these changes.' }

# Check every file before changing any of them.
$files = foreach ($package in $packages) {
    $root = Join-Path $repo "symlinks\$package"
    foreach ($file in Get-ChildItem -LiteralPath $root -Recurse -File -Force) {
        $relative = $file.FullName.Substring($root.Length + 1)
        if ($relative -match '(^|\\)secrets(\\|$)') {
            throw "Refusing to install a secret from the repository: $package\$relative"
        }
        [pscustomobject]@{ Source = $file.FullName; Dest = Join-Path $Target $relative }
    }
}

foreach ($file in $files) {
    $source = $file.Source
    $dest = $file.Dest
    $existing = Get-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue

    if ($existing -and $existing.PSIsContainer) {
        throw "A directory is in the way: $dest"
    }
    if ($existing -and $existing.LinkType -eq 'SymbolicLink' -and "$($existing.Target)" -eq $source) {
        Write-Output "up to date: $dest (link)"
        continue
    }
    if ($existing -and -not $useLinks -and -not $existing.LinkType -and
        (Get-FileHash -LiteralPath $dest).Hash -eq (Get-FileHash -LiteralPath $source).Hash) {
        Write-Output "up to date: $dest (copy)"
        continue
    }

    if ($existing) {
        Write-Output "back up: $dest -> $dest.bak-$stamp"
        if ($Apply) { Move-Item -LiteralPath $dest -Destination "$dest.bak-$stamp" }
    }
    if ($useLinks) {
        Write-Output "link: $dest -> $source"
    } else {
        Write-Output "copy: $source -> $dest"
    }
    if (-not $Apply) { continue }

    New-Item -ItemType Directory -Force (Split-Path $dest) | Out-Null
    if ($useLinks) {
        if (-not (New-Symlink $dest $source)) { throw "Could not link $dest" }
    } else {
        Copy-Item -LiteralPath $source -Destination $dest
    }
}

# OpenCode merges opencode.json with opencode.jsonc, so a leftover one still applies.
$config = Join-Path $Target '.config\opencode'
if (Test-Path -LiteralPath (Join-Path $config 'opencode.json')) {
    Write-Warning "OpenCode also reads $config\opencode.json; move it away unless you want it merged."
}
# Secrets stay manual; only report missing ones, never read them.
$jsonc = Get-Content -Raw (Join-Path $repo 'symlinks\windows\.config\opencode\opencode.jsonc')
$names = [regex]::Matches($jsonc, '\{file:~/\.config/opencode/secrets/([^}]+)\}') |
    ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique
foreach ($name in $names) {
    if (-not (Test-Path -LiteralPath (Join-Path $config "secrets\$name"))) {
        Write-Warning "Missing secret: $config\secrets\$name (see README.md, Private settings)"
    }
}
