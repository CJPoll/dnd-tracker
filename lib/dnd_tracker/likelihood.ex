defmodule DndTracker.Likelihood do
  defstruct things: []

  @not_found :"$not_found"

  def new do
    %__MODULE__{}
  end

  def chance(%__MODULE__{things: things}, weight, outcome) do
    %__MODULE__{things: [{weight, outcome} | things]}
  end

  def outcome(%__MODULE__{things: [_not | _empty] = things}) do
    things = Enum.reverse(things)

    max =
      Enum.reduce(things, 0, fn {weight, _outcome}, sum ->
        sum + weight
      end)

    roll = :rand.uniform(max)

    {_sum, result} =
      Enum.reduce(things, {0, @not_found}, fn
        {weight, outcome}, {sum, @not_found} ->
          sum = weight + sum

          if sum >= roll do
            {sum, outcome}
          else
            {sum, @not_found}
          end

        {_weight, _outcome}, {sum, result} ->
          {sum, result}
      end)

    result
  end
end
