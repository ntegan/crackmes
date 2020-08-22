#!/bin/bash

# Check that user entered a username to try with the "keygenme" program
function die { echo $1; exit 1; }
test $# = 1 || die "Usage: $0 <username>"

# compile keygen
test -f keygen || gcc keygen.c -o keygen

# Make sure the keygenme program is here so we can test it
test -f keygenme || die "Error: keygenme program not in current directory"

user="$1"
key="$(./keygen "${user}" 2>/dev/null)" || \
  die "Couldn't run keygen $(./keygen "${user}")"

echo -e "Trying keygenme program with user:pass = ${user}:${key}\n\n"


echo "Program output:"
./keygenme <<EOF
${user}
${key}
EOF


