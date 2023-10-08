defmodule DndTracker.Characters.Races.Elf do
  defstruct []

  def new, do: %__MODULE__{}

  defimpl DndTracker.Characters.Race do
    def ability_score_modifiers(_race), do: %{dexterity: 2}
    def base_speed(_race), do: 25
    def languages(_race), do: [:common, :elvish]
    def proficiencies(_race), do: [:perception]
    def resistances(_race), do: []
    def saving_throw_advantages(_race), do: [:charmed]
    def size(_race), do: :medium
    def vision(_race), do: %{darkvision: 60, dim: 60}
    def weapon_proficiencies(_race), do: [:battleaxe, :handaxe, :light_hammer, :war_hammer]
  end
end
