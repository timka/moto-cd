#!/usr/bin/env zsh

# FLAGS

if (( ! ${+MOTO_CD_CHPWD} )); then
    MOTO_CD_CHPWD=true
fi

if (( ! ${+MOTO_CD_HOME} )); then
    MOTO_CD_HOME=$HOME
fi

if (( ! ${+MOTO_CD_NO_AUTO_LS} )); then
    MOTO_CD_NO_AUTO_LS=false
fi

if (( ! ${+MOTO_CD_FILE} )); then
    MOTO_CD_FILE="$HOME/.last_cd"
fi

# change directory

{
    # disable auto-ls if needed
    if [ $MOTO_CD_NO_AUTO_LS = true ]; then
        moto_ls_index=${chpwd_functions[(I)auto-lss]}
        if [[ $moto_ls_index != 0 ]]; then
            to_remove=auto-lss
            chpwd_functions=("${chpwd_functions[@]/$to_remove}")
        fi
    fi

    # source and change dir
    if [[ -f "$MOTO_CD_FILE" ]]; then
        OLD_PATH=$(cat "$MOTO_CD_FILE")
        cd "$OLD_PATH"
    else
        cd "$MOTO_CD_HOME"
    fi
} always {

    # check auto-ls
    if [[ $MOTO_CD_NO_AUTO_LS -eq true ]]; then
        if [[ $moto_ls_index != 0 ]]; then
            chpwd_functions+=(auto-lss)
        fi
    fi


}

# functions

function moto-cd-init-cd {
    CURR_PWD=$(pwd)
    echo "$CURR_PWD" > "$MOTO_CD_FILE"
}

# append hook function

if [[ ${MOTO_CD_CHPWD} == true && ${chpwd_functions[(I)moto-cd-init-cd]} -eq 0 ]]; then
    chpwd_functions+=(moto-cd-init-cd)
fi
