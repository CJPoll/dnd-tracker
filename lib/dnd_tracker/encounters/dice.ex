defmodule DndTracker.Encounters.Dice do
  use Ecto.Schema

  import Ecto.Changeset

  schema "dice" do
    field :average, :float
    field :count, :integer, default: 1
    field :value, :integer
    field :modifier, :integer, default: 0

    timestamps()
  end

  def changeset(data, params) do
    data
    |> cast(params, [:average, :count, :value, :modifier])
    |> validate_required([:average, :value])
  end

  @legal_values [2, 3, 4, 6, 8, 10, 12, 20]

  def new(count \\ 1, value)

  def new(count, value) when value in @legal_values do
    average = dice_average(value) * count

    %__MODULE__{average: average, count: count, value: value}
  end

  def new(count, value, modifier) when value in @legal_values do
    average = dice_average(value) * count + modifier

    %__MODULE__{average: average, count: count, value: value, modifier: modifier}
  end

  def dice_syntax(%__MODULE__{count: count, value: value, modifier: 0}) do
    "#{count}d#{value}"
  end

  def dice_syntax(%__MODULE__{count: count, value: value, modifier: modifier})
      when modifier > 0 do
    "#{count}d#{value}+#{modifier}"
  end

  def dice_syntax(%__MODULE__{count: count, value: value, modifier: modifier})
      when modifier < 0 do
    "#{count}d#{value}-#{abs(modifier)}"
  end

  def roll(%__MODULE__{count: 1, value: value, modifier: modifier}) do
    :rand.uniform(value) + modifier
  end

  def roll(%__MODULE__{count: count, value: value, modifier: modifier}) do
    sum =
      Enum.reduce(1..count, 0, fn _, sum ->
        roll = 1 |> new(value) |> roll

        sum + roll
      end)

    sum + modifier
  end

  def with_average(average, dice_type \\ Enum.random(@legal_values)) do
    dice_count = trunc(2 * average / dice_type)
    dice_count = if dice_count < 1, do: 1, else: dice_count

    actual_average = dice_average(dice_type) * dice_count
    modifier = trunc(average - actual_average)

    new(dice_count, dice_type, modifier)
  end

  def average(%__MODULE__{value: value, count: count, modifier: modifier}) do
    trunc(dice_average(value) * count) + modifier
  end

  def dice_average(dice_type) do
    (dice_type + 1) / 2
  end

  def distribution(%__MODULE__{value: value, count: count, modifier: modifier}) do
    start = for _n <- 1..trunc(:math.pow(value, count)), do: []

    start
    |> Enum.with_index()
    |> Enum.map(fn {row, i} ->
      1..count
      |> Enum.with_index()
      |> Enum.reduce(row, fn {die_number, _j}, row ->
        # remainder = rem(i, trunc(:math.pow(value, index + 1)))
        remainder = rem(trunc(i / :math.pow(value, die_number - 1)), value)

        [remainder + 1 | row]
      end)
    end)
    |> Enum.map(fn row ->
      Enum.reduce(row, 0, fn n, sum ->
        n + sum + modifier
      end)
    end)
  end

  defimpl Inspect do
    import Inspect.Algebra

    alias DndTracker.Encounters.Dice

    def inspect(dice, _opts) do
      separator = " | "

      concat([
        "#Dice<",
        "Formula: ",
        Dice.dice_syntax(dice),
        separator,
        "Average: ",
        inspect(dice.average),
        ">"
      ])
    end
  end

  def standard_deviation(%__MODULE__{} = dice) do
    distribution = distribution(dice)
    mean = mean(distribution)

    distribution
    |> Enum.map(fn n -> :math.pow(n - mean, 2) end)
    |> mean
    |> :math.sqrt()
  end

  defp mean(numbers) do
    sum = Enum.reduce(numbers, 0, &+/2)
    sum / Enum.count(numbers)
  end

  def to_params(%__MODULE__{} = dice) do
    %{
      average: dice.average,
      count: dice.count,
      value: dice.value,
      modifier: dice.modifier
    }
  end
end
