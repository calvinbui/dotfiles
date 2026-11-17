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
- `profiles/wsl-desktop`: a Debian/WSL baseline, plus the `linux` package.
  OpenCode uses a minimal Linux config and shared instructions. Neovim is
  deliberately excluded; leave this machine's existing setup alone.

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

## Install and link

Install prerequisites for your OS:

```sh
# Debian / Ubuntu / WSL:
sudo apt update
sudo apt install stow zsh git curl

# macOS (install Homebrew first if needed):
brew install stow
```

From the repository root:

```sh
scripts/install-oh-my-zsh.sh       # before stowing zsh on a fresh machine
scripts/install-zsh-plugins.sh     # p10k + plugins; rerun to update them

scripts/stow-profile.sh wsl-desktop          # dry run (default)
scripts/stow-profile.sh wsl-desktop --apply  # actually create/restow links
# On the Mac, use macbook instead of wsl-desktop.
```

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
3. Check `~/.oh-my-zsh/custom/` for obsolete Dotbot links as well.
4. Preserve machine-specific Git settings in a real, untracked `~/.gitlocal`.
   This used to be a managed link; it is no longer part of a Stow package.
5. Apply the selected profile and test a new shell.

The Mac's signing key also used to live in the tracked `.gitlocal`. Set the
appropriate key locally on each machine; the platform package only selects its
credential helper/GPG executable:

```sh
git config --file ~/.gitlocal user.signingkey YOUR_KEY_ID
```

Back up/move a legacy `.gitlocal` link first. Never write through it into the old
repository path or another platform's config.

## Packages

| Package | Links |
|---------|-------|
| git | `.gitconfig`, `.gitignore_global` |
| linux | platform Zsh/Git hooks, minimal `.config/opencode/opencode.jsonc` |
| macos | platform Zsh/Git hooks, Mac OpenCode config, `Library/KeyBindings/DefaultKeyBinding.dict` |
| nvim | `.config/nvim/init.lua` |
| opencode | `.config/opencode/AGENTS.md` |
| python | `.pylintrc`, `.config/pycodestyle` |
| ssh | `.ssh/config` |
| terraform | `.terraformrc` |
| zsh | `.zshrc`, `.p10k.zsh`, `.oh-my-zsh/custom/*.zsh` |

### Still to check on Linux/WSL

- Neovim: intentionally left alone and excluded from the WSL profile. The shared
  config still needs `vim.pack` (Neovim 0.12+); do not migrate it here by default.
- Git: verify the signing key and credential-storage choice on each machine.
  The existing shared config uses `credential.helper=store` (plaintext on disk);
  the Mac adds Keychain. Linux credential storage needs a deliberate choice.
- Review work-specific aliases/environment variables separately from OS support.

## Private settings

Keep secrets and private hostnames out of the repo. Recreate only the files you
need locally, with restrictive permissions (`chmod 600`):

- `~/.gitlocal`: signing key and other machine-specific Git settings.
- `~/.zshrc.local`: shell overrides; loaded last.
- `~/.ssh/config.local`: private `Host` entries, included by `.ssh/config`.
- `~/.config/opencode/secrets/domain`: domain used in config URLs, no trailing newline.
- `~/.config/opencode/secrets/actual-mcp-token`.

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
`scripts/backup-brewfile.sh` regenerates it, skipping the slow dump unless
something was installed/uninstalled since.
`scripts/install-packages-darwin.sh` installs missing packages without upgrades.
VS Code extensions are excluded (Settings Sync owns them), as is npm (fnm owns
Node).
