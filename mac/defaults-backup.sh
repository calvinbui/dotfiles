#!/usr/bin/env bash

# start clean
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

rm -rf defaults/*

domains="$(defaults domains)"

readarray -td, a <<<"$domains,"; unset 'a[-1]';

for domain in "${a[@]}"
do
  domain=$(echo "$domain" | sed 's/^[[:space:]]*//')
  if keys=$(defaults read "$domain" 2>/dev/null); then
    echo "$keys" > "${DIR}/defaults/${domain}"
  fi
done
