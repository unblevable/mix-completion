# ! /usr/bin/env bash

# Bash completion for Elixir's build tool, Mix


_mix()
{
    # COMPREPLY=()
    local current="${COMP_WORDS[COMP_CWORD]}"
    local previous="${COMP_WORDS[COMP_CWORD - 1]}"

    local exs="tasks.exs"
    chmod +x "$exs"
    local tasks=($(./$exs))
    local separator=" "
    local task_list="$(printf "${separator}%s" "${tasks[@]}")"
    task_list="${task_list:${#separator}}"

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
    # if [[ ${1} == -* ]] ; then
        COMPREPLY=($(compgen -o filenames -- ${current}))
    # else
        # COMPREPLY=($(compgen -o filenames -- ${current}))
    # fi
}

complete -F _mix mix
