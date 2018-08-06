#!/usr/bin/env bash

# Helps our traps which need access to some vars to do their job properly.
set -o errtrace
set -o errexit
set -o nounset
set -o pipefail

declare lint_files
declare action
declare files

lint_files=( {core,response,storage,test,tests,util}/*.sh ./meemaw.sh )
action="$1"
shift

case "$action" in
  lint)
      files=( ${@:-"${lint_files[@]}"} )
      shellcheck --exclude=SC2128 "${files[@]}"
      # dockerfilelint ./Dockerfile
    ;;

  test)
      ./test/test.sh ${@}
    ;;

  *)
    echo "Invalid argument '$action'"
esac