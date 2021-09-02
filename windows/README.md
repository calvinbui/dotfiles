# Windows

## Backup Chocolatey

Install `choco-package-list-backup` to re-install all other packages

```
$ choco install choco-package-list-backup --params "/DONTRUN /NOSCHEDULE"
```

Trigger a backup running it's `.bat` script. This will create a new backup inside of the `Documents` folder.
