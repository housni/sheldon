################################################################################
# Sheldon: The not-so-bashful Bash framework. Bazinga!
#
# @namespace N/A
# @copyright Copyright 2015, Housni Yakoob (http://housni.org)
# @license http://opensource.org/licenses/bsd-license.php The BSD License
################################################################################

# Version check.
# Sheldon has only been tested on 4.3.30(1)-release
[[ ${BASH_VERSION} =~ ([^\.]).([^\.])* ]]
if [[ ${BASH_REMATCH[1]} < 4
   || ${BASH_REMATCH[1]} = 4 && ${BASH_REMATCH[2]} < 3 ]]; then
  echo "WARNING: Sheldon has only been tested with Bash 4.3* but you are" \
       "using version ${BASH_VERSION}"
fi


# Our traps need access to some vars to do their job properly.
set -o errtrace
set -o functrace


# Less eager word splitting - no space.
IFS=$'\n\t'


# Setting and reserving some of Sheldons variables.
# We know he doesn't like it when someone is in his spot.
declare -A Sheldon
Sheldon_tmp=''
Sheldon[register]=
Sheldon[dir]="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
Sheldon[root]="$(cd "$(dirname "${Sheldon[dir]}")" && pwd)"
Sheldon[file]="${Sheldon[dir]}/$(basename "${BASH_SOURCE[0]}")"
Sheldon[base]="$(basename ${Sheldon[file]} .sh)"


# Source a few commonly used libraries.
. "${Sheldon[dir]}/core/Sheldon.sh"
. "${Sheldon[dir]}/core/Libraries.sh"


################################################################################
# Assigns the value in $2 to the value of $1.
# $1 should be the name of the variable, prefixed with '=', that is passed into
# the parent function. _assign() will eval the value of $1 and assign it to $2
# which would be an actual value.
# It's important that $1 is prefixed with a '=' or no assignation will take place.
#
# This must be used in every Sheldon script that wishes to assign value to a
# variable inside a function and have that be visible outside the scope of the
# function. We use this so that the user can control the name of the variable
# and not pollute the variable namespace.
#
# Not ideal but this is the best you can do with Bash, I suppose.
#
# ### Usage
#
# ```
#   Sheldon.add() {
#     calculated=$(($2 + $3))
#     _assign "$1" "${calculated}"
#   }
#
#   declare SUM
#
#   Sheldon.add =SUM 4 5
#   echo "${SUM}" # will yield '9'
# ```
# If you want to, you can directly assign the value to the second parameter of
# _assign(), inside add(), like this:
# ```
#   _assign "$1" "$(($2 + $3))"
# ```
#
# @param string $1
#     The name of the variable you want to assign $2 to. This is typically
#     passed in from the code written by the user. Sheldon simply handles it.
# @param integer $2
#     The value you want to assign to the variable named held in $1.
################################################################################
_assign() {
  if [[ "$1" = =* ]]; then
    local name="${1:1}"
    eval "$name=(\"\$2\")"
  fi
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

  Sheldon::Core::Libraries::load 'Sheldon::Util::String'

  case "$#" in
    0)
      # TODO: check for UTF-8 terminal before using Unicode.
      printf "$(< "${Sheldon[dir]}/resources/templates/errors/0.tpl")"
      ;;

    1)
      string="$(< "${Sheldon[dir]}/resources/templates/errors/1.tpl")"
      placeholders=( ['message']="${1}" )
      Sheldon::Util::String::insert =Sheldon_tmp "${string}" placeholders
      printf "${Sheldon_tmp}"
      ;;

    3|4)
      string="$(< "${Sheldon[dir]}/resources/templates/errors/$#.tpl")"
      placeholders=( ['message']="${1}" ['line']="${2}" ['file']="${3}" )
      Sheldon::Util::String::insert =Sheldon_tmp "${string}" placeholders
      printf "${Sheldon_tmp}"
      ;;

    *)
      echo "Invalid number of arguments ($#) for '_error()'"
  esac

  if [[ $# = 4 ]]; then
    exit $4
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
# use Sheldon::Storage::Registry
#
# Sheldon::Storage::Registry::set 'name' 'Sheldon'
# Sheldon::Storage::Registry::set 'has' 'Eidetic memory'
# ```
#
# ### Shortened usage
#
# On the other hand, you can give the long function name an alias (NOTE: This is
# not the same as an alias in Bash). Then, the alias becomes a variable which
# you can use to access functions with:
# ```
# use Sheldon::Storage::Registry as Registry
#
# $Registry::set 'who' 'Sheldon'
# $Registry::set 'has' 'Eidetic memory'
# ```
#
# The latter is preferred over the former just because it's a lot more readable
# and much less cluttered. Readability matters!
#
# Due to the way Bash handles variables, the alias would be $3 and not $2. If
# you look at the syntax, 'as' would be $2 and the alias would be $3.
#
# @see Sheldon::Core::Libraries::load()
# @param string $1
#     The full function name minus the last part.
# @param string $2 optional
#     This will always be the string 'as'.
# @param string $3 optional
#     The name of the alias.
################################################################################
use() {
  Sheldon::Core::Libraries::load "${1}"

  # If a third param is present, treat it as an alias.
  if [[ ! -z "${3+x}" ]]; then
    eval "$3"="$1"
  fi
}


# Set the traps.
for sig in INT TERM EXIT; do
    trap "[[ $sig == EXIT ]] || kill -$sig $BASHPID" $sig
done
trap _error ERR