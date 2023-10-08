defmodule DndTracker.Adventures.NPCs do
  use DndTracker.Constants
  alias DndTracker.Likelihood

  constant(:allies, [
    "Skilled adventurer",
    "Inexperienced adventurer",
    "Enthusiastic commoner",
    "Soldier",
    "Priest",
    "Sage",
    "Revenge seeker",
    "Raving lunatic",
    "Celestial ally",
    "Fey ally",
    "Disguised monster",
    "Villain posing as an ally"
  ])

  def random_villian do
    Likelihood.new()
    |> Likelihood.chance(1, "Beast or monstrosity with no particular agenda")
    |> Likelihood.chance(1, "Aberration bent on corruption or domination")
    |> Likelihood.chance(1, "Fiend bent on corruption or destruction")
    |> Likelihood.chance(1, "Dragon bent on domination and plunder")
    |> Likelihood.chance(1, "Giant bent on plunder")
    |> Likelihood.chance(2, "Undead with any agenda")
    |> Likelihood.chance(1, "Fey with a mysterious goal")
    |> Likelihood.chance(2, "Humanoid cultist")
    |> Likelihood.chance(2, "Humanoid conqueror")
    |> Likelihood.chance(1, "Humanoid seeking revenge")
    |> Likelihood.chance(2, "Humanoid schemer seeking to rule")
    |> Likelihood.chance(1, "Humanoid criminal mastermind")
    |> Likelihood.chance(2, "Humanoid raider or ravager")
    |> Likelihood.chance(1, "Humanoid under a curse")
    |> Likelihood.chance(1, "Misguided humanoid zealot")
    |> Likelihood.outcome()
  end

  def random_patron do
    Likelihood.new()
    |> Likelihood.chance(2, "Retired adventurer")
    |> Likelihood.chance(2, "Local ruler")
    |> Likelihood.chance(2, "Military officer")
    |> Likelihood.chance(2, "Temple official")
    |> Likelihood.chance(2, "Sage")
    |> Likelihood.chance(2, "Respected elder")
    |> Likelihood.chance(1, "Deity or celestial")
    |> Likelihood.chance(1, "Mysterious fey")
    |> Likelihood.chance(1, "Old friend")
    |> Likelihood.chance(1, "Former teacher")
    |> Likelihood.chance(1, "Parent or other family member")
    |> Likelihood.chance(1, "Desperate commoner")
    |> Likelihood.chance(1, "Embattled merchant")
    |> Likelihood.chance(1, "Villain posing as a patron")
    |> Likelihood.outcome()
  end
end
