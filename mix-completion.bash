# ! /usr/bin/env bash

# Bash completion for Elixir's build tool, Mix

_mix()
{
    local cwd second current previous more_previous exs tasks separator task_list task_list_file

    COMPREPLY=()

    cwd="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    current="${COMP_WORDS[COMP_CWORD]}"
    previous="${COMP_WORDS[COMP_CWORD - 1]}"
    more_previous="${COMP_WORDS[COMP_CWORD - 2]}"
    second="${COMP_WORDS[1]}"

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

        echo "$task_list" >> "$task_list_file"
    else
        task_list=$(head -1 "$task_list_file")
    fi

    case "${previous}" in
        mix)                mix_complete_tasks; return 0;;
        archive)            mix_complete_custom "--no-compile"; return 0;;
            -i)                 mix_complete_directories '!*'; return 0;;
            -o)                 mix_complete_files; return 0;;
        clean)              mix_complete_custom "--all"; return 0;;
        cmd)                mix_complete_commands; return 0;;
        compile)            mix_complete_multi "--list"; return 0;;
        # mix_complete_deps
        deps.clean)         mix_complete_custom "--all --unlock"; return 0;;
        deps.compile)       mix_complete_custom "--quiet"; return 0;;
        deps.get)           mix_complete_custom "--no-compile --no-deps-check --quiet"; return 0;;
        # mix_complete_deps
        deps.unlock)        mix_complete_custom "--all"; return 0;;
        # mix_complete_deps
        deps.update)        mix_complete_custom "-- all --no-compile --no-deps-check --quiet"; return 0;;
        do)                 mix_complete_tasks; return 0;;
        escriptize)         mix_complete_custom "--force --no-compile"; return 0;;
        local.install)      mix_complete_custom "--force"; return 0;;
        local.rebar)        mix_complete_files; return 0;;
        local.uninstall)    mix_complete_tasks; return 0;;
        #fix
        help)               if [[ ! ${more_previous} == "help" ]] ; then mix_complete_tasks; fi; return 0;;
        new)                mix_complete_multi "--bare --module --umbrella"; return 0;;
        run)                mix_complete_multi "--eval --require --parallel-require, --no-halt, --no-compile, --no-start"; return 0;;
        test)               mix_complete_multi "--trace --max-cases --cover --force --no-compile --no-start --no-color"; return 0;;
            --cover)            mix_complete_directories; return 0;;
        *)
            if [[ ("${second}" == "do" && "${previous:(-1)}" == ",") ]] ; then mix_complete_tasks; fi
            return 0;;
    esac

    return 0
}

get_task_list()    { echo "what"; }

mix_complete_commands()     { COMPREPLY=($(compgen -c -- ${current})); }
mix_complete_custom()       { if [[ ${current} == --* ]] ; then COMPREPLY=($(compgen -W "${1}" -- ${current})); fi }
mix_complete_directories()  { COMPREPLY=($(compgen -d -X -- ${current})); }
mix_complete_files()        { COMPREPLY=($(compgen -f -X -- ${current})); }
mix_complete_tasks()        { COMPREPLY=($(compgen -W "${task_list}" -- ${current})); }
mix_complete_multi()        { if [[ ${current} == --* ]] ; then COMPREPLY=($(compgen -W "${1}" -- ${current})); else mix_complete_files; fi }

complete -F _mix mix
