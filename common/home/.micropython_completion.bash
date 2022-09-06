#/usr/bin/env bash

_board_suboption() {
    local prev=${1%%=*} cur=${1#*=}
    BOARDS=$(ls boards/*/mpconfigboard.h | cut -d'/' -f2)
    COMPREPLY=($(compgen -W "$BOARDS" -- "$cur"))
    return 0
}

_comp_board_check() {
    # Get prev and cur words without splitting on =
    local cureq=$(_get_cword :=) preveq=$(_get_pword :=)

    if [[ $cureq == *BOARD=* ]]; then
        _board_suboption $cureq "${1-}"
        return $?
    fi

    return 1
}

_micropython_completions() {
    local cur prev words cword
    _init_completion || return

    if [[ $PWD == *micropython* ]]; then
        _comp_board_check "$1" && return
        if [[ $cur == B* ]]; then
            compopt -o nospace
            COMPREPLY=("BOARD=")
        fi
    fi
}

#complete -r blaze
complete -F _micropython_completions blaze
