# This file is used to define functions under the niso.* namespace.

# Set $niso_pkg to "apt-get" or "yum", or abort.
#
if which apt-get >/dev/null 2>&1; then
  export niso_pkg=apt-get
elif which yum >/dev/null 2>&1; then
  export niso_pkg=yum
fi

if [ "$niso_pkg" = '' ]; then
  echo 'niso only supports apt-get or yum!' >&2
  exit 1
fi

# Mute STDOUT and STDERR
#
function niso.mute() {
  echo "Running \"$@\""
  `$@ >/dev/null 2>&1`
  return $?
}

# Installer
#
function niso.installed() {
  if [ "$niso_pkg" = 'apt-get' ]; then
    dpkg -s $@ >/dev/null 2>&1
  elif [ "$niso_pkg" = 'yum' ]; then
    rpm -qa | grep $@ >/dev/null
  fi
  return $?
}

# When there's "set -e" in install.sh, niso.install should be used with if statement,
# otherwise the script may exit unexpectedly when the package is already installed.
#
function niso.install() {
  if niso.installed "$@"; then
    echo "$@ already installed"
    return 1
  else
    echo "No packages found matching $@. Installing..."
    niso.mute "$niso_pkg -y install $@"
    return 0
  fi
}
