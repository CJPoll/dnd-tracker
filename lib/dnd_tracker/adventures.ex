defmodule DndTracker.Adventures do
  alias DndTracker.Encounters.Dice
  alias DndTracker.Adventures.Goals

  @type adventure_type :: :wilderness | :dungeon | :other

  def generate(:wilderness) do
    random_unique(Goals.wilderness(), goal_count())
  end

  def generate(:dungeon) do
    random_unique(Goals.dungeon(), goal_count())
  end

  def generate(:other) do
    random_unique(Goals.other(), 1)
  end

  def goal_count do
    roll =
      20
      |> Dice.new()
      |> Dice.roll()

    if roll == 20, do: 2, else: 1
  end

  def random_unique(options, count \\ 1, selected \\ [])
  def random_unique(_options, count, selected) when count == length(selected), do: selected

  def random_unique(options, count, selected) when options != [] and count >= 1 do
    option = Enum.random(options)
    selected = Enum.uniq([option | selected])

    random_unique(options, count, selected)
  end
end
