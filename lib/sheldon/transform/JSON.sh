#!/usr/bin/env bash

# Converts an associative Bash array into JSON.
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
  local colon
  local comma
  data="$1"
  __shld_result="$2"
  colon="<sheldon>:<sheldon>"
  comma="<sheldon>,<sheldon>"

  # shellcheck disable=SC1004
  serialized=$(gawk -v colon="$colon" -v comma="$comma" 'BEGIN {
      # States that affect "stack":
      # 0 = no-save
      # 1 = save
      # 2 = saving
      state = 0
      count = 0

      # Indice of character inside "stack".
      indice = 0
    }
    /"[^"]*"/ \
    {
      split($0, chars, "")
      for (char in chars) {
        # Start saving to stack and set state to "saving" if:
        #   current state is "save"
        #     and if the char is not }
        if (state >= 1 && 0 == match(chars[char], /\}/)) {
          indice++
          stack[indice] = chars[char]
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
            delete stack[indice]
            state = 0

            separator = comma
            if ((count % 2) == 0) {
              separator = colon
            }
            count++
            stack[indice] = separator
          }
        }
      }
    } END {
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
    key=$(get_part "$serialized" "$colon")
    serialized="$(chop_string "$serialized" "$colon" "$key")"

    val="$(get_part "$serialized" "$comma")"
    serialized="$(chop_string "$serialized" "$comma" "$val")"
    # shellcheck disable=SC2034
    __shld_result["$key"]="$val"
  done
}