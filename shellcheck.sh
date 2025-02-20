#!/bin/bash
# like https://github.com/syntaqx/git-hooks/blob/master/hooks/shellcheck.sh
# but with brew install

set -eu

# https://www.shellcheck.net/
test -n "$(whereis -q shellcheck)" || {
    brew install shellcheck
    hash -r
}

# Filter out non-shell files, if we can.
new_args=( )
if command -v file >/dev/null 2>&1; then
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
