# ! /usr/bin/env bash

# Bash completion for Elixir's build tool, Mix

_mix()
{
    local cwd current previous more_previous exs tasks separator task_list task_list_file superoption i j

    COMPREPLY=()

    cwd="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    current="${COMP_WORDS[COMP_CWORD]}"
    previous="${COMP_WORDS[COMP_CWORD - 1]}"
    more_previous="${COMP_WORDS[COMP_CWORD - 2]}"

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
        tasks=($task_list)
    fi

    case "${previous}" in
        mix)
            mix_complete_tasks
            ;;
        archive)
            mix_complete_custom "${previous}"
            ;;
            -i)
                mix_complete_directories
                ;;

            -o)
                mix_complete_files
                ;;
        clean)              mix_complete_wordlist "--all"; return 0;;
        cmd)                mix_complete_commands; return 0;;
        compile)            mix_complete_wordlist"--list"; return 0;;
        # mix_complete_deps
        deps.clean)         mix_complete_custom "${previous}"; return 0;;
        deps.compile)       mix_complete_wordlist "--quiet"; return 0;;
        deps.get)           mix_complete_custom "${previous}"; return 0;;
        # mix_complete_deps
        deps.unlock)        mix_complete_wordlist "--all"; return 0;;
        # mix_complete_deps
        deps.update)        mix_complete_custom "${previous}"; return 0;;
        do)                 mix_complete_tasks; return 0;;
        escriptize)         mix_complete_custom "${previous}"; return 0;;
        local.install)      mix_complete_wordlist"--force"; return 0;;
        local.rebar)        mix_complete_files; return 0;;
        local.uninstall)    mix_complete_tasks; return 0;;
        #fix
        help)               if [[ ! ${more_previous} == "help" ]] ; then mix_complete_tasks; fi; return 0;;
        new)                mix_complete_custom "${previous}"; return 0;;
        run)                mix_complete_custom "${previous}"; return 0;;
        test)               mix_complete_custom "${previous}"; return 0;;
            --cover)            mix_complete_directories; return 0;;
        *)
            # retrive the last superoption, i.e. the last option that is not a suboption
            for (( i=${#COMP_WORDS[@]} - 1; i >= 0; i-- ))
            do
                for (( j=${#tasks[@]} - 1; j >= 0; j-- ))
                do
                    if [[ "${COMP_WORDS[i]}" == "${tasks[j]}"  ]] ; then
                        superoption="${tasks[j]}"
                        break 2
                    fi
                done
            done

            if [[ ("${COMP_WORDS[1]}" == "do" && "${previous:(-1)}" == ",") ]] ; then
                mix_complete_tasks
            elif [[ ! -z "$superoption" && ! "$superoption" == "${current}" ]] ; then
                mix_complete_custom "$superoption"
            fi

            return 0;;
    esac

    return 0
}

get_task_list()    { echo "what"; }

mix_complete_commands()     { COMPREPLY=($(compgen -c -- ${current})); }
mix_complete_custom()
{
    case $1 in
        archive)
            mix_complete_wordlist "--no-compile"
            ;;
        deps.clean)
            mix_complete_wordlist "--all --unlock";
            ;;
        deps.get)
            mix_complete_wordlist "--no-compile --no-deps-check --quiet"
            ;;
        deps.update)
            mix_complete_wordlist "-- all --no-compile --no-deps-check --quiet"
            ;;
        escriptize)
            mix_complete_wordlist "--force --no-compile"
            ;;
        new)
            mix_complete_multi "--bare --module --umbrella"
            ;;
        run)
            mix_complete_multi "--eval --require --parallel-require --no-halt --no-compile --no-start"
            ;;
        test)
            mix_complete_multi "--trace --max-cases --cover --force --no-compile --no-start --no-color"
            ;;
        *)
            ;;
    esac

}
mix_complete_directories()  { COMPREPLY=($(compgen -d -- ${current})); }
mix_complete_files()        { COMPREPLY=($(compgen -f -- ${current})); }
mix_complete_tasks()        { COMPREPLY=($(compgen -W "${task_list}" -- ${current})); }
mix_complete_multi()        { if [[ ${current} == --* ]] ; then COMPREPLY=($(compgen -W "${1}" -- ${current})); else mix_complete_files; fi }
mix_complete_wordlist()     { if [[ ${current} == --* ]] ; then COMPREPLY=($(compgen -W "${1}" -- ${current})); fi }

complete -F _mix mix
