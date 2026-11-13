#!/bin/sh
set -eu

# allow apps from anywhere (adds "Anywhere" to System Settings > Privacy & Security)
if [ "$(spctl --status)" != "assessments disabled" ]; then
  sudo spctl --master-disable
fi
