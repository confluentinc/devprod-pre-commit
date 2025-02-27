#!/bin/bash
# like https://github.com/syntaqx/git-hooks/blob/master/hooks/shellcheck.sh
# but with brew install

set -eu

func_fatal() {
    echo "$@" >&2
    exit 1
}

func_have_command() {
    command -v "$1" >/dev/null 2>&1
}

# https://www.shellcheck.net/
if ! func_have_command shellcheck; then
    if func_have_command brew; then
        brew install shellcheck
    elif func_have_command apt; then
        sudo apt -y install shellcheck
    elif func_have_command yum; then
        sudo yum install shellcheck
    else
        func_fatal "Can't figure out how to install shellcheck on this $(uname -s) system"
    fi
    hash -r
fi

# Filter out non-shell files, if we can.
new_args=( )
if func_have_command file; then
    for arg in "$@"; do
        if [ -f "${arg}" ]; then
            case "$(file --brief --mime-type "${arg}")" in
                *shellscript) new_args[${#new_args[@]}]="${arg}" ;;
            esac
        else
            # Pass non-file args through unchanged
            new_args[${#new_args[@]}]="${arg}"
            continue
        fi
    done
fi

shellcheck "${new_args[@]}"
