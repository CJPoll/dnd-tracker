defmodule DndTracker.Characters.Abilities.Ability do
  use DndTracker.StructHelpers

  defstruct [:name, value: 10]

  constructor()

  getters([:name, :value])
  setters([:name, :value])
end
