# ! /usr/bin/env bash

# Bash completion for Elixir's build tool, Mix

_mix()
{
    local current previous exs tasks separator task_list task_list_file

    COMPREPLY=()

    current="${COMP_WORDS[COMP_CWORD]}"
    previous="${COMP_WORDS[COMP_CWORD - 1]}"

    task_list_file="task_list"
    # create a cache if it doesn't exist
    if [ ! -f "$task_list_file" ] ; then
        # tasks.exs outputs a space-delimted string of Mix tasks
        exs="tasks.exs"
        chmod +x "$exs"

        tasks=($(./$exs))

        # join array with spaces
        separator=" "
        task_list="$(printf "${separator}%s" "${tasks[@]}")"
        task_list="${task_list:${#separator}}"

        touch "$task_list_file"
        echo "$task_list" >> "$task_list_file"
    else
        while read line
        do
            task_list=$(echo "$line")
        done < $task_list_file
    fi

    case "${previous}" in
        archive)    _mix_option $current "--no-compile"; return 0;;
        clean)      _mix_option $current "--all"; return 0;;
        compile)    _mix_option $current "--list"; return 0;;
        *)
        ;;
    esac

    COMPREPLY=($(compgen -W "${task_list}" -- ${current}))
    return 0
}

# @current @option
_mix_option()
{
    if [[ ${1} == --* ]] ; then
        COMPREPLY=($(compgen -W "${2}" -- ${current}))
    fi
}

complete -F _mix mix
