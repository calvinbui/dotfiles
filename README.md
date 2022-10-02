# Dotfiles

⚠️⚠️⚠️  **Read these instructions before continuing** ⚠️⚠️⚠️

## Mac

1. Install homebrew from https://brew.sh
1. Disable homebrew analytics by running `brew analytics off`
1. Install git by running `brew install git`
1. Generate a new SSH key to `~/.ssh/id_rsa` and `chmod 700 ~/.ssh/id_rsa` it
1. Generate a new SSH key by running `ssh-keygen -t ed25519 -C 3604363+calvinbui@users.noreply.github.com`
1. Copy the public key by running `pbcopy < ~/.ssh/id_ed25519.pub`
1. Add the SSH key into GitHub at https://github.com/settings/keys
1. Clone this repo + submodules and install:

```bash
mkdir ~/repos
cd ~/repos
ssh-keyscan github.com >> ~/.ssh/known_hosts
git clone --recurse-submodules git@github.com:calvinbui/dotfiles.git
cd dotfiles
./install -x
```

## Linux

1. Generate a new SSH key to `~/.ssh/id_rsa` and `chmod 700 ~/.ssh/id_rsa` it
1. Generate a new SSH key by running `ssh-keygen -t ed25519 -C 3604363+calvinbui@users.noreply.github.com`
1. Copy the public key `cat ~/.ssh/id_ed25519.pub`
1. Add the SSH key into GitHub at https://github.com/settings/keys
1. Clone this repo + submodules and install:

```bash
mkdir ~/repos
cd ~/repos
ssh-keyscan github.com >> ~/.ssh/known_hosts
git clone --recurse-submodules git@github.com:calvinbui/dotfiles.git
cd dotfiles
./install
```

## Windows

1. Start an admin PowerShell window
1. Enable PowerShell to run scripts first by running `Set-ExecutionPolicy Bypass -Scope Process`
1. Run the `windows\install-chocolately.ps1` script within the admin shell
1. Re-install all packages by running `choco install windows\packages.config`


### Notes:
  - Not all packages will create Desktop icons
  - `wsl2` requires a restart before installing any Linux distros
  - `wsl-ubuntu-2004` is installed but needs to ran to be installed as a distro
