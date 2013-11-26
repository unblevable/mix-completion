#! /usr/bin/env elixir

Mix.Task.load_all

Mix.Task.all_modules
|>  Enum.filter(fn(x) -> not Mix.Task.hidden?(x) end)
|>  Enum.map_join(" ", fn(x) -> Mix.Task.task_name(x) end)
|>  IO.write
# lc module inlist Mix.Task.all_modules, not Mix.Task.hidden?(module), do: IO.puts Mix.Task.task_name(module)
