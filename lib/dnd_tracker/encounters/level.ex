defmodule DndTracker.Encounters.Level do
  defstruct [:level]

  @weak_levels [0, 1 / 8, 1 / 4, 1 / 2, 1]

  defguard is_weak_level(level) when level in @weak_levels
  defguard is_strong_level(level) when is_integer(level) and level > 1
  defguard is_level(level) when is_strong_level(level) or is_weak_level(level)

  def new(level) when is_level(level) do
    %__MODULE__{level: level}
  end

  def variance(%__MODULE__{level: level}) do
    case level do
      l when l <= 1 -> 0
      2 -> :rand.uniform(2) - 1
      _ -> :rand.uniform(3) - 1
    end
  end

  def decrement(%__MODULE__{} = l, 0), do: l

  def decrement(%__MODULE__{level: 0} = l, _amount), do: l

  def decrement(%__MODULE__{} = level, %__MODULE__{level: amount}) do
    decrement(level, amount)
  end

  def decrement(%__MODULE__{level: level}, amount) when level > 1 do
    decrement(%__MODULE__{level: level - 1}, amount - 1)
  end

  def decrement(%__MODULE__{level: level}, amount) when is_weak_level(level) do
    index = Enum.find_index(@weak_levels, &(&1 == level))

    @weak_levels
    |> Enum.at(index - 1)
    |> new()
    |> decrement(amount - 1)
  end

  def increment(%__MODULE__{} = l, 0), do: l

  def increment(%__MODULE__{level: level}, %__MODULE__{level: amount}) do
    increment(level, amount)
  end

  def increment(%__MODULE__{level: level}, amount) when level >= 1 do
    %__MODULE__{level: level + amount}
  end

  def increment(%__MODULE__{level: level}, amount) when level < 1 do
    index = Enum.find_index(@weak_levels, level)

    @weak_levels
    |> Enum.at(index + 1)
    |> increment(amount - 1)
  end
end
