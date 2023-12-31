defmodule DndTracker.Encounters.XP do
  use DndTracker.Encounters.Calculable,
    values: %{
      0 => 0,
      (1 / 8) => 25,
      (1 / 4) => 50,
      (1 / 2) => 100,
      1 => 200,
      2 => 450,
      3 => 700,
      4 => 1_100,
      5 => 1_800,
      6 => 2_300,
      7 => 2_900,
      8 => 3_900,
      9 => 5_000,
      10 => 5_900,
      11 => 7_200,
      12 => 8_400,
      13 => 10_000,
      14 => 11_500,
      15 => 13_000,
      16 => 15_000,
      17 => 18_000,
      18 => 20_000,
      19 => 22_000,
      20 => 25_000,
      21 => 33_000,
      22 => 41_000,
      23 => 50_000,
      24 => 62_000,
      25 => 75_000,
      26 => 90_000,
      27 => 105_000,
      28 => 120_000,
      29 => 135_000,
      30 => 155_000
    }
end
