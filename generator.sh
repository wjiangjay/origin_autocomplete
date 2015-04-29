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
    if [[ $valid_commands != "" ]];
    then
        if [[ $valid_options != "" ]];
        then
            _display ${valid_options[*]}
        fi
        _display ${valid_commands[*]}
        for valid_command in ${valid_commands[*]};
        do
            _process_function "$command $valid_command" 
        done 
    else
        _display ${valid_options[*]}
    fi
}

_display()
{
    echo $*|tr , " "
}

_valid_command()
{
   echo "" 
}

_valid_options()
{
    echo ""
}

_process_function $1
