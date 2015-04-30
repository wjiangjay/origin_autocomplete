#!/bin/env bash

## use to generate the bash autocomplete script

## TODO : some command use `command options`


_process_function()
{
    local command valid_commands valid_options flag
    command=$1
    echo "======= $command ======"
    if [[ `$command --help 2>&1|grep "Options:"` == "" ]]
    then
        flag=0
        valid_commands=(`$command --help 2>&1|grep -A 100 "Available Commands:"|grep -B 100 "^$"|grep -v "Available Commands:"|grep -v ^$ |awk '{print $1}'`)
    else
        flag=1
        valid_commands=(`$command --help 2>&1|grep -A 100 "Available Commands:"|grep -B 100 "Options:"|grep -B 100 "^$"|grep -v "Available Commands:"|grep -v ^$ |awk '{print $1}'`)
    fi
    valid_options=(`$command --help 2>&1|grep -A 100 "Options"|grep -B 100 "^$"|grep -v "Options:"|grep -v ^$ |awk -F= '{print $1}'`)


    if [[ $command == $cmd ]];then
            $(cat >> $output <<EOF
    if [ \$COMP_CWORD -eq 1 ]; then
        if [[ "\$cur" == -* ]]; then
            opts="$(_display ${valid_options[*]})"
        elif [ -z \$cur ]; then
            opts="$(_display ${valid_commands[*]})"
        else
            opts="$(_display ${valid_commands[*]})"
        fi
    else
        prev="\${COMP_WORDS[@]:0:COMP_CWORD}"
        SAVE_IFS=\$IFS
        IFS=" "
        case "\${prev[*]}" in)
    else
        `cat >> $output <<EOF
        "$command")
            if [[ "\\$cur" == -* ]];then
                opts="$(_display ${valid_options[*]})"
            else
                opts="$(_display ${valid_commands[*]})"
            fi
        ;;`
    fi

    if [[ $valid_commands != "" ]];
    then
        for valid_command in ${valid_commands[*]};
        do
            _process_function "$command $valid_command"
        done
    fi
}

_display()
{
    echo $*|tr , " "
}

cmd=$1
output=$2
if [[ `which $cmd` == "" ]];then
    echo "The command you provide \"$cmd\" is not existed, please check"
else
    if [[ $# -le 1 ]];then
        echo "Do not give enough arguments."
    else
        $(cat >> $output <<EOF
_${cmd}()
{
    local cur opts prev
    COMPREPLY=()
    cur="\${COMP_WORDS[COMP_CWORD]}")
        _process_function $1
    $(cat >> $output <<EOF
        esac
        IFS=\$SAVE_IFS
    fi

    COMPREPLY=( \$(compgen -W "\${opts}" -- \${cur}))
    return 0
}

    complete -o default -F _${cmd} ${cmd}



)
    fi
fi
