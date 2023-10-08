defmodule DndTracker.Characters.Abilities do
  defstruct [:strength, :dexterity, :constitution, :intelligence, :wisdom, :charisma]

  def new do
    %__MODULE__{
      strength: 10,
      dexterity: 10,
      constitution: 10,
      intelligence: 10,
      wisdom: 10,
      charisma: 10
    }
  end
end
