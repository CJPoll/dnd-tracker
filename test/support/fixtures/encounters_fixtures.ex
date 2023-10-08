defmodule DndTracker.EncountersFixtures do
  alias DndTracker.Encounters.Dice
  alias DndTracker.Repo

  @moduledoc """
  This module defines test helpers for creating
  entities via the `DndTracker.Encounters` context.
  """

  @defaults %{
    name: "Enemy Name",
    description: "Default value",
    ac: 10,
    attacks: [],
    hp: 2 |> Dice.with_average(2) |> Dice.to_params()
  }

  @doc """
  Generate a enemy.
  """
  def enemy_fixture(campaign, attrs \\ %{}) do
    attrs = Enum.into(attrs, @defaults)
    {:ok, enemy} = DndTracker.Encounters.create_enemy(campaign, attrs)
    Repo.preload(enemy, :campaign)
  end
end
