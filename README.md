# dotfiles

macOS dotfiles, symlinked into `~` with [GNU Stow](https://www.gnu.org/software/stow/).
Repo lives at `~/repos/dotfiles`.

```
symlinks/   stow packages, one per tool; each mirrors the layout of ~
scripts/    setup scripts, run by hand (nothing runs automatically)
Brewfile    snapshot of installed Homebrew packages
```

## Symlinks

```sh
cd ~/repos/dotfiles/symlinks
stow */                 # link every package
stow zsh git            # or just some
stow -R zsh             # restow after adding/removing files in a package
stow -D zsh             # remove a package's links
stow -n -v zsh          # dry run
```

`symlinks/.stowrc` sets `--target=~` and `--no-folding`, so commands must be run from
inside `symlinks/`. No-folding means only files get linked, never whole directories, so
tools writing into e.g. `~/.config/nvim` or `~/.ssh` don't put junk in the repo.

Adding a file: move it into the matching package at the same path relative to `~`,
then `stow -R <package>`. e.g. `~/.config/foo/bar` → `symlinks/foo/.config/foo/bar`.

If stow reports a conflict, a real file already exists at the target. Delete it (or
`stow --adopt <package>` to pull it into the repo, then check `git diff`).

| package   | links                                                      |
|-----------|------------------------------------------------------------|
| git       | `.gitconfig`, `.gitignore_global`, `.gitlocal`             |
| macos     | `Library/KeyBindings/DefaultKeyBinding.dict`               |
| nvim      | `.config/nvim/init.lua`                                    |
| opencode  | `.config/opencode/AGENTS.md`, `.config/opencode/opencode.jsonc` |
| python    | `.pylintrc`, `.config/pycodestyle`                         |
| ssh       | `.ssh/config`                                              |
| terraform | `.terraformrc`                                             |
| zsh       | `.zshrc`, `.p10k.zsh`, `.oh-my-zsh/custom/*.zsh`           |

## New machine

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install stow

git clone <dotfiles repo url> ~/repos/dotfiles
cd ~/repos/dotfiles

scripts/install-oh-my-zsh.sh      # before stowing zsh
scripts/install-zsh-plugins.sh    # p10k + zsh plugins (rerun to update them)
(cd symlinks && stow */)
scripts/install-packages-darwin.sh
```

Secrets and private hostnames are kept out of the repo. Recreate these by hand (`chmod 600`):

- `~/.ssh/config.local`: private `Host` entries (pulled in by `Include` in `.ssh/config`)
- `~/.config/opencode/secrets/domain`: the domain used in `opencode.jsonc` URLs (no trailing newline)
- `~/.config/opencode/secrets/actual-mcp-token`, `~/.config/opencode/secrets/playwright-mcp-extension-token`

Then whichever of the remaining `scripts/` you want (macOS defaults, Touch ID sudo,
Rosetta, python.org Python, etc.). Each is safe to rerun.

## Packages (Homebrew)

`Brewfile` is a snapshot of what's installed. `scripts/backup-brewfile.sh` regenerates
it (skips the slow dump unless something was installed/uninstalled since);
`scripts/install-packages-darwin.sh` installs whatever's missing (no upgrades).
vscode extensions excluded (VS Code Settings Sync owns them), npm excluded (fnm owns
node).
