#! /usr/bin/env elixir

Mix.Task.load_all

Mix.Task.all_modules
|>  Enum.sort
|>  Enum.map_join(" ", &Mix.Task.task_name/1)
|>  IO.write
