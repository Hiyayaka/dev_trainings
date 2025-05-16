#!/bin/sh
echo -ne '\033c\033]0;Dev_Trainings\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Dev_Trainings.x86_64" "$@"
