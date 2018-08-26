#!/usr/bin/env bash

# Version check.
# Sheldon is only supported on bash 4.3+
# We are assuming that the shell is Bash, though.
[[ ${BASH_VERSION} =~ ([^\.]).([^\.])* ]]
if [[ ${BASH_REMATCH[1]} -lt 4
   || ${BASH_REMATCH[1]} -eq 4 && ${BASH_REMATCH[2]} -lt 3 ]]; then
  echo "WARNING: Sheldon is only supported on bash 4.3 and greater but you are" \
       "using version ${BASH_VERSION}"
fi

# Our traps need access to some vars to do their job properly.
set -o errtrace
set -o functrace

# Less eager word splitting - no space.
IFS=$'\n\t'

# Setting and reserving some of Sheldons variables.
# We know he doesn't like it when someone is in his spot.
declare -A __SHELDON
__SHELDON[registry]=
__SHELDON[root]="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__SHELDON[lib]="${__SHELDON[root]}"
__SHELDON[log_level]=1

# Logs text to screen with formatting to make it easier to catch in the midst
# of a lot of output.
#
#   __SHELDON[log_level]=1
#   declare -a SHELDON_LOG_ARGS
#   SHELDON_LOG_ARGS=(
#       3         # Top/bottom padding of 3 lines
#       "@@@   "  # Prepend characters
#       "   @@@"  # Postpend characters
#   )
#   _log "Doing task X" "${SHELDON_LOG_ARGS[@]}"
#
# $1 (string, required) The text to display.
# $2 (integer, optional, default=0) The 'padding' above and below $1.
# $3 (string, optional, default="") This will 'prepend' $1.
# $4 (string, optional, default="") This will 'postpend' $1.
_log() {
    if [[ ${__SHELDON[log_level]} -eq 0 ]]; then
        return
    fi

    local -i padding
    local prepend
    local postpend
    local -i first
    local -i counter

    padding=${2:-0}
    prepend=${3:-""}
    postpend=${4:-""}
    first=$(( padding + 1 ))

    for((counter=1;counter<=first;counter++)); do
        if [[ $first -eq $counter ]]; then
            echo -e "${prepend}$1${postpend}"
        else
            echo
        fi
    done

    for((counter=1;counter<=padding;counter++)); do
        echo
    done
}

################################################################################
# Displays an error message and the optional line number, file name and exit
# code before exiting.
#
# ### Usage
#
# Generic error message (default):
# ```
#   _error
# ```
# This will cause your script to exit with exit code 1 after displaying a very
# generic error message. Not advisable. Verbose errors are preferred.
#
# Custom error message:
# ```
#   _error 'My error message'
# ```
# This is a little better. Your custom error message is displayed before the
# script is exited.
#
# Custom error message with line number and script name:
# ```
# _error 'My error message' 42 'foo.sh'
# ```
# An error message along with the line number and script name are displayed
# before the exit. If you only supplied the line number or the file name, this
# function will not work. You have to either supply both or neither.
#
# Custom error message with line number and script name and exit code:
# ```
# _error 'My error message' 42 'foo.sh' 2
# ```
# Same as above except the script will exit with the exit code '2'.
#
# ### Tips
#
# Consider using '${LINENO}' in scripts when you want to pass in the line number.
# The error messages can be customized by editing the templates located in
# sheldon/resources/templates/errors/*.tpl
#
# @param string $1 optional
#     Custom error message.
# @param integer $2 optional
#     Line number where the error occurred. Must be used together with $3.
# @param string $3 optional
#     File name where the error occurred. Must be used together with $2.
# @param integer $4 optional
#     Exit code. Supplying this will cause the script to exit with the error
#     code in $4.
################################################################################
_error() {
  local -A placeholders
  local string

  Sheldon.Core.Libraries.load 'Sheldon.Util.String'

  case "$#" in
    0)
      # TODO: check for UTF-8 terminal before using Unicode.
      # shellcheck disable=SC1117
      printf "%b\n" "$(< "${__SHELDON[root]}/resources/templates/errors/0.tpl")"
      ;;

    1)
      string="$(< "${__SHELDON[root]}/resources/templates/errors/1.tpl")"
      placeholders=( ['message']="${1}" )
      # shellcheck disable=SC1117
      printf "%s\n" "$(Sheldon.Util.String.insert "${string}" placeholders)"
      ;;

    3|4)
      string="$(< "${__SHELDON[root]}/resources/templates/errors/$#.tpl")"
      # shellcheck disable=SC2034
      placeholders=( ['message']="${1}" ['line']="${2}" ['file']="${3}" )
      # shellcheck disable=SC1117
      printf "%s\n" "$(Sheldon.Util.String.insert "${string}" placeholders)"
      ;;

    *)
      echo "Invalid number of arguments ($#) for '_error()'"
  esac

  if [[ $# -eq 4 ]]; then
    exit "$4"
  fi
  exit 1
}


################################################################################
# Loads (sources) the script specified by $1. load() is able to work out the
# location of the script based on the name of the function name which, for
# Sheldons purposes, can be thought of as a namespace.
#
# ### Default usage
#
# You can load a script the default way but you'd have to use the entire
# namespace when you want to use its functions:
# ```
# import Sheldon.Storage.Registry
#
# Sheldon.Storage.Registry.set 'name' 'Sheldon'
# Sheldon.Storage.Registry.set 'has' 'Eidetic memory'
# ```
#
# ### Shortened usage
#
# On the other hand, you can give the long function name an alias (NOTE: This is
# not the same as an alias in Bash). Then, the alias becomes a variable which
# you can use to access functions with:
# ```
# import Sheldon.Storage.Registry as Registry
#
# $Registry.set 'who' 'Sheldon'
# $Registry.set 'has' 'Eidetic memory'
# ```
#
# The latter is preferred over the former just because it's a lot more readable
# and much less cluttered. Readability matters!
#
# Due to the way Bash handles variables, the alias would be $3 and not $2. If
# you look at the syntax, 'as' would be $2 and the alias would be $3.
#
# @see Sheldon.Core.Libraries.load()
# @param string $1
#     The full function name minus the last part.
# @param string $2 optional
#     This will always be the string 'as'.
# @param string $3 optional
#     The name of the alias.
################################################################################
import() {
  Sheldon.Core.Libraries.load "${1}"

  # If a third param is present, treat it as an alias.
  if [[ ! -z "${3+x}" ]]; then
    eval "$3"="$1"
  fi
}


################################################################################
# If a function doesn't exist, this function is called by Bash, which, in turn,
# will search for a user defined function named `__call()` and if that exists,
# it will be called with the function name as the first argument and the
# parameters as the following arguments.
# This behaves similar to PHP's `__call()` magic method.
# 
# ### Usage
#
# ```
#   __call() {
#     if [ "$1" = "legacyAdd" ] || [ "$1" = "newAdd" ]; then
#       local -i first=$2
#       local -i second=$3
#       
#       echo $((first + second))
#     else
#       exit 127
#     fi
#   }
#   
#   legacyAdd 1 2 # Output: 3
#   newAdd 1 2 # Output: 3
#   blahAdd 1 2 # Exits with 127
# ```
################################################################################
# command_not_found_handle() {
#   if declare -F | grep -q __call; then
#     __call "$@"
#   fi
# }

# Source a few commonly used libraries.
# shellcheck source=/dev/null
. "${__SHELDON[lib]}/core/Sheldon.sh"
# shellcheck source=/dev/null
. "${__SHELDON[lib]}/core/Libraries.sh"

# Set the traps.
for sig in INT TERM EXIT; do
  # shellcheck disable=SC2064
  trap "[[ '$sig' == EXIT ]] || kill -'$sig' '$BASHPID'" $sig
done
trap _error ERR

# Make debugging easier
# See: http://wiki.bash-hackers.org/scripting/debuggingtips#making_xtrace_more_useful
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
