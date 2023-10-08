defmodule DndTracker.Encounters.Calculable do
  defmacro __using__(values: values) do
    quote do
      def values do
        unquote(values)
      end

      alias DndTracker.Encounters.Level

      def for_level(%Level{} = level) do
        for_level(level.level)
      end

      def for_level(level) do
        Map.get(values(), level)
      end

      def levels_for(value) do
        values()
        |> Stream.filter(fn
          {_level, val} when is_integer(val) or is_float(val) ->
            value == val

          {_level, %Range{} = val} ->
            value in val
        end)
        |> Stream.map(fn {level, _value} -> level end)
        |> Enum.to_list()
        |> Enum.sort()
      end
    end
  end
end
