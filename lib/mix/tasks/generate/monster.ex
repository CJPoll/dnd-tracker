defmodule Mix.Tasks.Generate.Monster do
  use Mix.Task
  use DndTracker.Log
  use DndTracker.Constants

  import DndTracker.Encounters.Enemies
  alias DndTracker.Encounters.Enemies

  @args_schema [
    level: :integer,
    defensive: :boolean,
    offensive: :boolean
  ]

  def run(args) do
    {parsed_args, _leftovers} = OptionParser.parse!(args, strict: @args_schema)

    monster_type = select_monster_type(parsed_args)

    enemy =
      parsed_args
      |> select_level()
      |> Enemies.generate(monster_type)

    Log.inspect(enemy)
  end

  defp select_level(parsed_args) do
    Keyword.get(parsed_args, :level, 1)
  end

  defp select_monster_type(parsed_args) do
    cond do
      has_type?(parsed_args, :defensive) -> :defensive
      has_type?(parsed_args, :offensive) -> :offensive
      true -> :balanced
    end
  end

  defp has_type?(parsed_args, type) when monster_types?(type) do
    Keyword.get(parsed_args, :defensive, nil)
  end
end
