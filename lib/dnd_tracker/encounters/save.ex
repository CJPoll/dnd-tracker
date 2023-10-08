defmodule DndTracker.Encounters.Save do
  use DndTracker.Encounters.Calculable,
    values: %{
      0 => 0..13,
      (1 / 8) => 13,
      (1 / 4) => 13,
      (1 / 2) => 13,
      1 => 13,
      2 => 13,
      3 => 13,
      4 => 14,
      5 => 15,
      6 => 15,
      7 => 15,
      8 => 16,
      9 => 16,
      10 => 16,
      11 => 17,
      12 => 17,
      13 => 18,
      14 => 18,
      15 => 18,
      16 => 18,
      17 => 19,
      18 => 19,
      19 => 19,
      20 => 19,
      21 => 20,
      22 => 20,
      23 => 20,
      24 => 21,
      25 => 21,
      26 => 21,
      27 => 22,
      28 => 22,
      29 => 22,
      30 => 23
    }
end
