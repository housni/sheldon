#!/usr/bin/env bash

Sheldon.Util.File.exists?() {
  if [[ -e "${1}" ]]; then
    echo 0
  else
    echo 1
  fi
}

Sheldon.Util.File.isDir?() {
  if [[ -d "${1}" ]]; then
    echo 0
  else
    echo 1
  fi
}

Sheldon.Util.File.isFile?() {
  if [[ -f "${1}" ]]; then
    echo 0
  else
    echo 1
  fi
}

Sheldon.Util.File.isLink?() {
  if [[ -L "${1}" ]]; then
    echo 0
  else
    echo 1
  fi
}

Sheldon.Util.File.isPipe?() {
  if [[ -p "${1}" ]]; then
    echo 0
  else
    echo 1
  fi
}