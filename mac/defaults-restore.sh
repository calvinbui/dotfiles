#!/usr/bin/env bash
cd defaults || exit
for filename in *; do
  domain="${filename%".plist"}"
  echo "restoring $domain"
  defaults import "$domain" "$filename"
done