# Dotfiles

## Mac
1. Install homebrew from https://brew.sh
1. Disable homebrew analytics by running `brew analytics off`
1. Install git by running `brew install git`
1. Add SSH key to `~/.ssh/id_rsa` and `chmod 700 ~/.ssh/id_rsa` it
1. Clone this repo + submodules and install:
```bash
mkdir ~/repos
cd ~/repos
ssh-keyscan github.com >> ~/.ssh/known_hosts
git clone --recurse-submodules https://github.com/calvinbui/dotfiles.git
cd dotfiles
./install
```
