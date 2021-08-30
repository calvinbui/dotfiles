# Windows

## Chocolatey

1. Start an admin PowerShell
2. Enable PowerShell to run scripts first by running: `Set-ExecutionPolicy Bypass -Scope Process`
3. Run the `install-chocolately.ps1` script within the admin shell
4. Try choco-package-list-backup first to re-install all other packages

```PowerShell
$ choco install choco-package-list-backup --params "/DONTRUN /NOSCHEDULE"
$ choco install packages.config
```

Notes:
  - some packages will not create desktop icons
  - wsl2 requires a restart before installing any distros
  - wsl-ubuntu-2004 is installed but needs to run afterwards to be installed as a distro
