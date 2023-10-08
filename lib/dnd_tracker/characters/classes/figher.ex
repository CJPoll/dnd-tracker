defmodule DndTracker.Characters.Classes.Fighter do
  defstruct []

  def new, do: %__MODULE__{}

  defimpl DndTracker.Characters.Class do
    def display_name(_class), do: "Fighter"

    def hit_die(_class), do: 8
  end
end
