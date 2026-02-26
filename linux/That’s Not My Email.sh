#!/bin/sh
printf '\033c\033]0;%s\a' That’s Not My Email
base_path="$(dirname "$(realpath "$0")")"
"$base_path/That’s Not My Email.x86_64" "$@"
