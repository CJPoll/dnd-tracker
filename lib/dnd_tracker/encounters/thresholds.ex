defmodule DndTracker.Encounters.Thresholds do
  alias DndTracker.Encounters.Level

  import DndTracker.Constants

  constant(:difficulty, [:easy, :medium, :hard, :deadly])

  def encounter_multiplier(monster_count) when is_integer(monster_count) and monster_count > 0 do
    cond do
      monster_count == 1 -> 1
      monster_count == 2 -> 1.5
      monster_count <= 6 -> 2
      monster_count <= 10 -> 2.5
      monster_count <= 14 -> 3
      true -> 4
    end
  end

  def threshold(%Level{level: level}, difficulty)
      when difficulty?(difficulty) do
    threshold(level, difficulty)
  end

  def threshold(level, difficulty) when difficulty?(difficulty) do
    difficulty
    |> distribution
    |> Map.get(level)
  end

  def distribution(difficulty) do
    apply(__MODULE__, difficulty, [])
  end

  def easy do
    %{
      1 => 25,
      2 => 50,
      3 => 75,
      4 => 125,
      5 => 250,
      6 => 300,
      7 => 350,
      8 => 450,
      9 => 550,
      10 => 600,
      11 => 800,
      12 => 1_000,
      13 => 1_100,
      14 => 1_250,
      15 => 1_400,
      16 => 1_600,
      17 => 2_000,
      18 => 2_100,
      19 => 2_400,
      20 => 2_800
    }
  end

  def medium do
    %{
      1 => 50,
      2 => 100,
      3 => 150,
      4 => 250,
      5 => 500,
      6 => 600,
      7 => 750,
      8 => 900,
      9 => 1_100,
      10 => 1_200,
      11 => 1_600,
      12 => 2_000,
      13 => 2_200,
      14 => 2_500,
      15 => 2_800,
      16 => 3_200,
      17 => 3_900,
      18 => 4_200,
      19 => 4_900,
      20 => 5_700
    }
  end

  def hard do
    %{
      1 => 75,
      2 => 150,
      3 => 225,
      4 => 375,
      5 => 750,
      6 => 900,
      7 => 1_100,
      8 => 1_400,
      9 => 1_600,
      10 => 1_900,
      11 => 2_400,
      12 => 3_000,
      13 => 3_400,
      14 => 3_800,
      15 => 4_300,
      16 => 4_800,
      17 => 5_900,
      18 => 6_300,
      19 => 7_300,
      20 => 8_500
    }
  end

  def deadly do
    %{
      1 => 100,
      2 => 200,
      3 => 400,
      4 => 500,
      5 => 1_100,
      6 => 1_400,
      7 => 1_700,
      8 => 2_100,
      9 => 2_400,
      10 => 2_800,
      11 => 3_600,
      12 => 4_500,
      13 => 5_100,
      14 => 5_700,
      15 => 6_400,
      16 => 7_200,
      17 => 8_800,
      18 => 9_500,
      19 => 10_900,
      20 => 12_700
    }
  end
end
