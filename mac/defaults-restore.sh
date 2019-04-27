#!/usr/bin/env bash

for filename in defaults/*; do
  echo "Restoring $filename"
  defaults import "$filename" "$filename"
done