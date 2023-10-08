defmodule DndTracker.Characters.Races do
  alias DndTracker.Characters.Race

  defdelegate ability_score_modifiers(race), to: Race
  defdelegate base_speed(race), to: Race
  defdelegate languages(race), to: Race
  defdelegate proficiencies(race), to: Race
  defdelegate resistances(race), to: Race
  defdelegate saving_throw_advantages(race), to: Race
  defdelegate size(race), to: Race
  defdelegate vision(race), to: Race
  defdelegate weapon_proficiencies(race), to: Race

  def ability_bonus(race, ability) do
    Map.get(Race.ability_score_modifiers(race), ability, 0)
  end
end
