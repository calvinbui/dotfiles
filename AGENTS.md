# Working on these dotfiles

- `symlinks/` contains GNU Stow packages mirroring paths relative to `$HOME`.
  Shared packages are named after tools; `macos`, `linux`, and (when needed) `wsl`
  contain platform-only additions. Do not create a second platform tree.
- `profiles/` lists the packages selected for each machine. Never recommend
  `stow */`: not every package belongs on every computer.
- Packages in the same profile must not own the same target file. Shared configs
  load platform hooks (`~/.config/dotfiles/platform.zsh` and
  `~/.config/git/platform.gitconfig`) and optional local overrides
  (`~/.zshrc.local` and `~/.gitlocal`). Platform packages are mutually exclusive.
- OpenCode's shared package owns `AGENTS.md`; platform packages own the complete
  `opencode.jsonc`. Keep Linux minimal unless the user asks to add services.
  Do not copy Mac providers, MCP servers, browser paths, or secret requirements
  to Linux automatically. OpenCode reloads configuration after file changes.
- Neovim is intentionally excluded from the WSL profile. Leave its installed
  version, config, and existing links alone unless the user asks otherwise.
- Use `$HOME`, not a username, checkout location, or another machine's paths.
  Guard optional tools before running them during shell startup.
- Keep secrets, private hostnames, and machine-specific signing keys out of Git.
  Do not read or print secret files while auditing.
- Preserve local edits, real home-directory files, and old submodule directories.
  Inspect conflicts; back up before migrating links. Never use `stow --adopt` or
  delete conflicting files without the user's explicit agreement.
- Profile application is separate from installation. Dry-run first with
  `scripts/stow-profile.sh <profile>`; `--apply` changes home-directory links.
  Do not apply profiles, install packages, or change login shells automatically.
- Keep platform setup scripts explicit and opt-in. Native Windows linking is not
  implemented yet; do not assume GNU Stow works on native Windows.
- Run `scripts/test-config.sh` after changes. Keep the README and profiles in sync.
