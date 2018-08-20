#!/usr/bin/env bash

# Converts Bashs associative array into JSON.
Sheldon.Transform.JSON.dumps() {
  local -n __shld_data
  local -a dump
  # shellcheck disable=SC2124
  __shld_data="$@"
  dump=()
  for datum in "${!__shld_data[@]}"; do
    dump+=( "\"$datum\":\"${__shld_data[$datum]}\"" )
  done
  joined="$( printf ",%s" "${dump[@]}" )"
  echo "{${joined:1}}"
}

# Requires gawk
#
# Converts a simple JSON object to a Bash array
# NOTE: Will only work with valid, 1 level deep arrays.
Sheldon.Transform.JSON.loads() {
  local data
  local -n __shld_result
  local token_1
  local token_2
  data="$1"
  __shld_result="$2"
  token_1="<sheldon>:<sheldon>"
  token_2="<sheldon>,<sheldon>"

  # shellcheck disable=SC1004
  serialized=$(gawk -v token_1="$token_1" -v token_2="$token_2" 'BEGIN {
      # States that affect "stack":
      # 0 = no-save
      # 1 = save
      # 2 = saving
      state = 0
      count = 0
    }
    /"[^"]*"/ \
    {
      split($0, chars, "")
      for (char in chars) {
        # Start saving to stack and set state to "saving" if:
        #   current state is "save"
        #     and if the char is not }
        if (state >= 1 && 0 == match(chars[char], /\}/)) {
          stack[char] = chars[char]
          state = 2
        }

        # Set state to "save" if:
        #   current char is the quotation char
        #     and we are not in a "no-save" state
        if (chars[char] == "\"" && state == 0) {
          state = 1
        }

        # If:
        #   current char is the quotation char
        #     and the state is "saving"
        if (chars[char] == "\"" && state == 2) {
          # If previous char is not a backslash:
          #   delete the last item in stack (it is going to be the closing quote)
          #   set state to "no-save"
          #   add a separator to "stack"
          #   store value of "char" since we will need it in the END section
          if (chars[char - 1] != "\\") {
            delete stack[char]
            state = 0

            separator = token_2
            if ((count % 2) == 0) {
              separator = token_1
            }
            count++

            stack[char] = separator
            final = char
          }
        }
      }
    } END {
      # Remove the last char since it will always be a comma
      delete stack[final]
      delete separators[final]

      for (item in stack) {
        printf "%s", stack[item]
      }
    }' \
   <<< "$data")

  # Get everything before $2
  get_part() {
    echo "${1/$2*/}"
  }

  # Remove everything upto first instance of $2
  chop_string() {
    tpl_len=${#2}
    key_len=${#3}
    part_len=$((key_len + tpl_len))
    echo "${1:part_len}"
  }

  # Grab keys/values and set them in $__shld_result
  while [[ -n "$serialized" ]]; do
    key=$(get_part "$serialized" "$token_1")
    serialized="$(chop_string "$serialized" "$token_1" "$key")"

    val="$(get_part "$serialized" "$token_2")"
    serialized="$(chop_string "$serialized" "$token_2" "$val")"

    # shellcheck disable=SC2034
    __shld_result["$key"]="$val"
  done
}