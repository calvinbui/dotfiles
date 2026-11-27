#!/bin/sh
set -eu

usage() {
  echo "Usage: $0 <profile> [--dry-run|--apply]" >&2
  exit 1
}

[ "$#" -ge 1 ] && [ "$#" -le 2 ] || usage
profile=$1
mode=${2:---dry-run}
case "$profile" in
  ''|*[!a-zA-Z0-9_-]*) usage ;;
esac
case "$mode" in
  --dry-run|--apply) ;;
  *) usage ;;
esac

repo=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
profile_file="$repo/profiles/$profile"
[ -f "$profile_file" ] || { echo "Unknown profile: $profile" >&2; exit 1; }
command -v stow >/dev/null 2>&1 || {
  echo "GNU Stow is required. Arch: sudo pacman -S stow; Debian/Ubuntu: sudo apt install stow; macOS: brew install stow" >&2
  exit 1
}

set --
while IFS= read -r package || [ -n "$package" ]; do
  case "$package" in
    ''|\#*) continue ;;
    *[!a-zA-Z0-9_-]*) echo "Invalid package in $profile_file: $package" >&2; exit 1 ;;
  esac
  [ -d "$repo/symlinks/$package" ] || {
    echo "Missing Stow package: $package" >&2
    exit 1
  }
  case "$package:$(uname -s)" in
    macos:Darwin|linux:Linux) ;;
    macos:*|linux:*|windows:*) echo "Package $package does not match this OS." >&2; exit 1 ;;
  esac
  set -- "$@" "$package"
done < "$profile_file"
[ "$#" -gt 0 ] || { echo "Empty profile: $profile" >&2; exit 1; }

# Read the repository's .stowrc; explicit flags also make the target unambiguous.
cd "$repo/symlinks"
if [ "$mode" = "--dry-run" ]; then
  set -- --simulate "$@"
fi
# Finder drops .DS_Store files in the package directories; never link them.
exec stow --dir="$repo/symlinks" --target="$HOME" --no-folding --restow --verbose \
  --ignore='\.DS_Store$' "$@"
