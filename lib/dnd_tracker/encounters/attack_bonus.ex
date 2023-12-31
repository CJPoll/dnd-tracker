defmodule DndTracker.Encounters.AttackBonus do
  use DndTracker.Encounters.Calculable,
    values: %{
      0 => 0..3,
      (1 / 8) => 3,
      (1 / 4) => 3,
      (1 / 2) => 3,
      1 => 3,
      2 => 3,
      3 => 4,
      4 => 5,
      5 => 6,
      6 => 6,
      7 => 6,
      8 => 7,
      9 => 7,
      10 => 7,
      11 => 8,
      12 => 8,
      13 => 8,
      14 => 8,
      15 => 8,
      16 => 9,
      17 => 10,
      18 => 10,
      19 => 10,
      20 => 10,
      21 => 11,
      22 => 11,
      23 => 11,
      24 => 12,
      25 => 12,
      26 => 12,
      27 => 13,
      28 => 13,
      29 => 13,
      30 => 14
    }
end
