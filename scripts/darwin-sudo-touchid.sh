#!/bin/sh
set -eu

# Touch ID for sudo. /etc/pam.d/sudo_local survives macOS updates
# (unlike editing /etc/pam.d/sudo directly); template ships with macOS.
if [ ! -f /etc/pam.d/sudo_local ]; then
  sudo sh -c 'sed "s/^#auth/auth/" /etc/pam.d/sudo_local.template > /etc/pam.d/sudo_local'
fi
