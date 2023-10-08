defmodule DndTracker.Characters.Abilities.Ability.Test do
  use ExUnit.Case
  use DndTracker.StructTest, test_module: DndTracker.Characters.Abilities.Ability

  defines_constructor()

  describe "name" do
    defines_getter(:name)
    defines_setter(:name)
  end

  describe "value" do
    defines_getter(:value)
    defines_setter(:value)
  end
end
