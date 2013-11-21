#! /usr/bin/env bash

# Bash completion for Elixir's build tool, Mix

_completemix()
{
    local cur prev opts base
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    IFS=""
    exs="tasks.exs"
    chmod +x "$exs"
    tasks=($(./$exs))
}
