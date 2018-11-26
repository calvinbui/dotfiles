#!/usr/bin/bash env

function line_separator() {
  cols=$(tput cols)
  for ((i=0; i<cols; i++)); do
    printf "=";
  done; echo
}

function heading() {
  heading=$(line_separator)
  heading+=$(figlet -f big "$1")
  heading+="\n"
  heading+=$(line_separator)

  echo -n "$heading" | lolcat
}

function run_helpers() {
  heading "EG"
  eg "$1" | tee

  heading "BROPAGES"
  bro "$1" | sed -E '/bro/d'

  heading "CHEAT"
  cheat "$1"

  heading "TLDR"
  tldr "$1"
}

alias help=run_helpers "$1"
