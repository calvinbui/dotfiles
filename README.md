# dotfiles

Shared and machine-specific dotfiles, linked into `~` with
[GNU Stow](https://www.gnu.org/software/stow/). The checkout can live anywhere.

```text
symlinks/   Stow packages: shared tools plus macos/linux platform additions
profiles/   explicit package selections for each machine
scripts/    opt-in setup and linking scripts (nothing runs automatically)
tests/      configuration checks, using temporary home directories
Brewfile    snapshot of installed macOS Homebrew packages
AGENTS.md   rules for AI-assisted maintenance
```

## Choose what each machine shares

- `profiles/macbook`: the existing Mac tools, plus the `macos` package.
- `profiles/wsl-desktop`: an Arch Linux/WSL baseline, plus the `linux` package.
  OpenCode uses a minimal Linux config and shared instructions. Neovim uses the
  same config as the Mac (Arch's `neovim` is new enough for `vim.pack`).

Profiles are plain text: one package per line, with blank lines and `#` comments
allowed. Create another profile when a computer needs a different selection.
Do **not** stow every package: `macos` and `linux` are alternatives.

Platform packages own different files from shared packages. The shared Zsh and
Git configs load platform hooks, then optional machine-only overrides:

| Purpose | Platform hook (Stow-managed) | Local override (not managed) |
|---------|-------------------------------|------------------------------|
| Zsh | `~/.config/dotfiles/platform.zsh` | `~/.zshrc.local` |
| Git | `~/.config/git/platform.gitconfig` | `~/.gitlocal` |

OpenCode shares `~/.config/opencode/AGENTS.md` through the `opencode` package.
Its complete `opencode.jsonc` belongs to the selected platform package instead:
Linux starts with only the schema; macOS retains its providers, MCP servers,
plugins, and skills. Linux does not require the Mac's secrets. Add integrations
separately when they are wanted on that machine.

After pulling this layout on the Mac, dry-run/restow **both** packages to move
ownership of the OpenCode config from `opencode` to `macos`:

```sh
cd symlinks
stow -n -v -R opencode macos
stow -R opencode macos
```

Inspect any conflicts first; the earlier `.gitlocal` migration still applies.

Linux settings also apply to WSL. Add a `wsl` package only when there are actual
WSL-only files/settings to manage; give it its own hook rather than conflicting
with Linux files. Native Windows support is not implemented yet: its smaller
config selection can live in this repo, but may need PowerShell-based linking.

## Set up Arch Linux on WSL

New-computer checklist (replace `NAME`). It assumes Git for Windows is
installed and this repository is already cloned on Windows.

1. From PowerShell, install Arch. It starts as `root` with no other user:

   ```powershell
   wsl --install archlinux
   ```

2. As root, run the opt-in setup script from the Windows checkout:

   ```sh
   sh /mnt/c/Users/NAME/repos/dotfiles/scripts/wsl-arch-setup.sh NAME
   ```

   It updates the system, installs the prerequisites below, creates `NAME` in
   the `wheel` group with passwordless sudo, makes it WSL's default user, sets a
   UTF-8 locale if none is configured (`LOCALE=...` overrides `en_US.UTF-8`),
   downloads zimfw, and sets `credential.helper` in `~/.gitlocal` to Git for
   Windows' Credential Manager (via WSL interop: browser sign-in, credentials
   shared with Windows, instead of the shared config's plaintext `store`). If
   Windows has `~/.local/bin/browse.exe`, it links `~/.local/bin/browse` to it
   so OpenCode's `browse` MCP server drives the Windows browser. It is
   safe to rerun. It does not link dotfiles or change the login shell.

3. From PowerShell, `wsl --terminate archlinux`, then reopen it as `NAME`.

4. Clone inside WSL (faster than linking from `/mnt/c`). Nothing reads
   `~/.gitlocal` until `~/.gitconfig` is linked, so pass the helper once;
   without it Git asks for a username and password:

   ```sh
   git -c "credential.helper=/mnt/c/Program\ Files/Git/ucrt64/bin/git-credential-manager.exe" \
     clone https://YOUR-GIT-HOST/NAME/dotfiles.git ~/repos/dotfiles
   ```

   Do not run `git config --global` before linking: a real `~/.gitconfig`
   blocks Stow.

5. Check, dry-run, and link (see [Install and link](#install-and-link)):

   ```sh
   cd ~/repos/dotfiles
   scripts/test-config.sh
   scripts/stow-profile.sh wsl-desktop
   scripts/stow-profile.sh wsl-desktop --apply
   ```

6. Add your GitHub SSH key. The shared `.gitconfig` fetches GitHub over SSH,
   so zimfw and `vim.pack` cannot download plugins without it:

   ```sh
   chmod 600 ~/.ssh/id_ed25519
   ssh -T git@github.com   # accept the host key once
   ```

   If the first shell started before this, run `zimfw reinstall`.

7. Import your GPG key (commits are signed), exported on another machine with
   `gpg --export-secret-keys --armor KEY_ID`, then delete the export:

   ```sh
   gpg --import key.asc
   gpg --edit-key KEY_ID   # trust, 5, y, quit
   git config --file ~/.gitlocal user.signingkey KEY_FINGERPRINT
   echo test | gpg --clearsign > /dev/null && echo signed-ok
   ```

8. Optionally switch to Zsh: `chsh -s /usr/bin/zsh`.

`.gitattributes` keeps LF line endings, so the scripts and configs also work
from a Windows checkout.

## Install and link

Install prerequisites for your OS:

```sh
# Arch Linux / WSL: scripts/wsl-arch-setup.sh (above) installs these, plus
# less (Git's pager), zoxide, fzf, neovim, gnupg and python-pip.

# Debian / Ubuntu:
sudo apt update
sudo apt install stow zsh git curl
curl -fsSL --create-dirs -o ~/.zim/zimfw.zsh \
  https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh

# macOS (install Homebrew first if needed; both are in the Brewfile):
brew install stow zimfw
```

From the repository root:

```sh
scripts/stow-profile.sh wsl-desktop          # dry run (default)
scripts/stow-profile.sh wsl-desktop --apply  # actually create/restow links
# On the Mac, use macbook instead of wsl-desktop.
```

Zsh plugins are [zimfw](https://zimfw.sh) modules listed in `~/.zimrc`. A new
shell installs any that are missing, and `zimfw update` updates them. Update
zimfw itself with `brew upgrade zimfw`, or `zimfw upgrade` without Homebrew. Run
`zimfw uninstall` after removing a module. Only Oh My Zsh's `git` aliases (and the
`lib` files they need) are still used, loaded as zimfw modules.

Linking does not install applications or change your login shell. The Mac also
has `scripts/install-packages-darwin.sh` for its Brewfile; there is no Linux
application bundle yet.

For individual packages:

```sh
cd symlinks
stow -n -v zsh             # dry run
stow zsh                  # link a shared tool
stow -R zsh               # restow after adding/removing package files
stow -D zsh               # unlink a package
```

`symlinks/.stowrc` sets `--target=~` and `--no-folding`. Run manual Stow commands
inside `symlinks/`; the profile script handles this for you.
No-folding prevents directory folding, so generated files in directories such as
`~/.config/nvim` or `~/.ssh` do not accidentally land in the repo.

Adding a file: put it in the appropriate package at the same path relative to
`~`, then dry-run/restow that package. For example,
`~/.config/foo/bar` → `symlinks/foo/.config/foo/bar`.

If Stow reports a conflict, inspect it and move it to a backup before retrying.
Do not blindly delete it or use `--adopt`, which can overwrite repository files.
When changing profiles, explicitly unstow packages you no longer want first;
applying a profile does not remove packages absent from it.

## Migrating an existing Dotbot installation

Pulling the Stow conversion does not update old links. Links to paths such as
`dotfiles/zsh/zshrc`, `dotfiles/git/linux`, or `dotfiles/ssh/config` may now be
dangling and will conflict with Stow.

1. Review the profile dry run and inspect existing links and real files.
2. Back up conflicting legacy links before applying the profile. Preserve actual
   local configs and leftover submodule directories; do not bulk-delete them.
3. Preserve machine-specific Git settings in a real, untracked `~/.gitlocal`.
   This used to be a managed link; it is no longer part of a Stow package.
4. Apply the selected profile and test a new shell.

The Mac's signing key also used to live in the tracked `.gitlocal`. Set the
appropriate key locally on each machine; the platform package only selects its
credential helper/GPG executable:

```sh
git config --file ~/.gitlocal user.signingkey YOUR_KEY_ID
```

Back up/move a legacy `.gitlocal` link first. Never write through it into the old
repository path or another platform's config.

## Migrating from Oh My Zsh

The custom files moved from `~/.oh-my-zsh/custom/` to `~/.config/zsh/`, so their
old links in `~/.oh-my-zsh/custom/` now dangle. History stays in `~/.zsh_history`.

1. Restow `zsh` (or reapply the profile) to link `~/.zimrc` and `~/.config/zsh/`.
2. Install zimfw (see above), then open a new shell; it installs the modules.
3. Once it works, move `~/.oh-my-zsh` to a backup and later delete it. Nothing
   reads it any more; zimfw keeps its own copy of the Oh My Zsh git plugin.

## Packages

| Package | Links |
|---------|-------|
| git | `.gitconfig`, `.gitignore_global` |
| linux | platform Zsh/Git hooks, minimal `.config/opencode/opencode.jsonc`, `.config/pip/pip.conf` (plain `pip install` on Arch) |
| macos | platform Zsh/Git hooks, Mac OpenCode config, `Library/KeyBindings/DefaultKeyBinding.dict` |
| nvim | `.config/nvim/init.lua`, `.config/nvim/nvim-pack-lock.json` |
| opencode | `.config/opencode/AGENTS.md` |
| python | `.pylintrc`, `.config/pycodestyle` |
| ssh | `.ssh/config` |
| terraform | `.terraformrc` |
| zsh | `.zshrc`, `.zimrc`, `.p10k.zsh`, `.config/zsh/*.zsh` |

### Still to check on Linux/WSL

- Git: verify the signing key and credential-storage choice on each machine.
  The existing shared config uses `credential.helper=store` (plaintext on disk);
  the Mac adds Keychain. On WSL, `scripts/wsl-arch-setup.sh` switches to Windows'
  Credential Manager in `~/.gitlocal`; other Linux machines still need a choice.
- Review work-specific aliases/environment variables separately from OS support.

## Private settings

Keep secrets and private hostnames out of the repo. Recreate only the files you
need locally, with restrictive permissions (`chmod 600`):

- `~/.gitlocal`: signing key and other machine-specific Git settings.
- `~/.zshrc.local`: shell overrides; loaded last.
- `~/.ssh/config.local`: private `Host` entries, included by `.ssh/config`.
- `~/.config/opencode/secrets/domain`: domain used in config URLs, no trailing newline.
- `~/.config/opencode/secrets/actual-mcp-token`.
- `~/.config/opencode/secrets/agentgateway-api-key`.

The OpenCode secret files above are for the Mac's integrations, not prerequisites
for the minimal Linux config.

## Checks

```sh
scripts/test-config.sh
```

Requires Python 3, Zsh, and Git. Stow integration checks run when Stow is
available. Tests use temporary home directories, not your live configuration.

## macOS setup scripts and packages

The remaining `scripts/darwin-*.sh` scripts are opt-in (macOS defaults, Touch ID
sudo, Rosetta, python.org Python, etc.).

`Brewfile` is a snapshot of installed Mac packages.
`scripts/backup-brewfile.sh` regenerates it, rewriting the file only when the
contents changed.
`scripts/install-packages-darwin.sh` installs missing packages without upgrades.
VS Code extensions are excluded (Settings Sync owns them), as is npm (fnm owns
Node).
