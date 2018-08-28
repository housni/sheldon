#!/usr/bin/env bash

Sheldon.Response.Formatter.error() {
  Sheldon.Response.Formatter.red "${1}"
}

Sheldon.Response.Formatter.info() {
  Sheldon.Response.Formatter.blue "${1}"
}

Sheldon.Response.Formatter.success() {
  Sheldon.Response.Formatter.green "${1}"
}

Sheldon.Response.Formatter.red() {
  local before
  local after

  before="$(tput bold)$(tput setaf 1)"
  after="$(tput sgr0)"

  printf "%s%s%s\\n" "${before}" "$1" "${after}"
}

Sheldon.Response.Formatter.green() {
  local before
  local after

  before="$(tput bold)$(tput setaf 2)"
  after="$(tput sgr0)"

  printf "%s%s%s\\n" "${before}" "$1" "${after}"
}

Sheldon.Response.Formatter.blue() {
  local before
  local after

  before="$(tput bold)$(tput setaf 4)"
  after="$(tput sgr0)"

  printf "%s%s%s\\n" "${before}" "$1" "${after}"
}