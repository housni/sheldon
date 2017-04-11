Sheldon.Util.File.exists?() {
  local _shld_assign

  _shld_assign="$1"

  if [ -e "${2}" ]; then
    _assign "$_shld_assign" 'true'
  else
    _assign "$_shld_assign" 'false'
  fi
}

Sheldon.Util.File.isDir?() {
  local _shld_assign

  _shld_assign="$1"

  if [ -d "${2}" ]; then
    _assign "$_shld_assign" 'true'
  else
    _assign "$_shld_assign" 'false'
  fi
}

Sheldon.Util.File.isFile?() {
  local _shld_assign

  _shld_assign="$1"

  if [ -f "${2}" ]; then
    _assign "$_shld_assign" 'true'
  else
    _assign "$_shld_assign" 'false'
  fi
}

Sheldon.Util.File.isLink?() {
  local _shld_assign

  _shld_assign="$1"

  if [ -L "${2}" ]; then
    _assign "$_shld_assign" 'true'
  else
    _assign "$_shld_assign" 'false'
  fi
}

Sheldon.Util.File.isSocket?() {
  local _shld_assign

  _shld_assign="$1"

  if [ -S "${2}" ]; then
    _assign "$_shld_assign" 'true'
  else
    _assign "$_shld_assign" 'false'
  fi
}