#! /usr/bin/env elixir

Mix.Task.load_all

Mix.Task.all_modules
|>  Enum.filter(fn(x) -> not Mix.Task.hidden?(x) end)
|>  Enum.sort
|>  Enum.map_join(" ", fn(x) -> Mix.Task.task_name(x) end)
|>  IO.write
