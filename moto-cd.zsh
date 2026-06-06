#!/usr/bin/env zsh

: ${MOTO_CD_CHPWD:=true}
: ${MOTO_CD_HOME:=$HOME}
: ${MOTO_CD_NO_AUTO_LS:=false}
: ${MOTO_CD_FILE:="$HOME/.last_cd"}

# Convert to absolute path if it is relative
[[ "$MOTO_CD_FILE" != /* ]] && MOTO_CD_FILE="$HOME/$MOTO_CD_FILE"

_moto_cd_restore() {
    # Remove itself from the precmd hook to avoid slowing down every subsequent prompt
    add-zsh-hook -D precmd _moto_cd_restore

    local target_dir=""
    if [[ -f "$MOTO_CD_FILE" ]]; then
        # $(<file) reads the file directly via Zsh, which is faster and safer than cat.
        # It automatically strips leading/trailing whitespace and newlines.
        target_dir=$(<"$MOTO_CD_FILE")
    else
        target_dir="$MOTO_CD_HOME"
    fi

    # Check if the directory exists and we are not already in it
    if [[ -d "$target_dir" && "$PWD" != "$target_dir" ]]; then

        local ls_disabled=false
        local ls_index=${chpwd_functions[(I)auto-lss]}

        # Temporarily disable auto-lss if needed (safe removal by index)
        if [[ "$MOTO_CD_NO_AUTO_LS" == true && $ls_index -ne 0 ]]; then
            chpwd_functions[$ls_index]=()
            ls_disabled=true
        fi

        # Execute cd. By this time, direnv and zsh-autoenv are fully ready
        # and will correctly react to this event via their chpwd hooks.
        cd "$target_dir" || return

        # Return auto-lss to the end of the hooks array
        if [[ "$ls_disabled" == true ]]; then
            chpwd_functions+=("auto-lss")
        fi
    fi
}

moto-cd-init-cd() {
    # $PWD is more reliable and faster than $(pwd).
    # print -r -- protects against special character interpretation.
    print -r -- "$PWD" > "$MOTO_CD_FILE"
}

# Ensure add-zsh-hook is available
autoload -Uz add-zsh-hook

# Register deferred restoration at startup
add-zsh-hook precmd _moto_cd_restore

# Register saving on every directory change
if [[ "$MOTO_CD_CHPWD" == true ]]; then
    if [[ ${chpwd_functions[(I)moto-cd-init-cd]} -eq 0 ]]; then
        chpwd_functions+=(moto-cd-init-cd)
    fi
fi
