defmodule DndTracker.EncountersTest do
  use DndTracker.DataCase

  alias DndTracker.Campaigns
  alias DndTracker.Encounters
  alias DndTracker.Encounters.Dice

  @valid_attrs %{
    name: "Enemy Name",
    description: "Default value",
    ac: 10,
    attacks: [],
    hp: 2 |> Dice.with_average(2) |> Dice.to_params()
  }

  setup do
    {:ok, campaign} = Campaigns.create_campaign(%{name: "test campaign"})
    {:ok, %{campaign: campaign}}
  end

  describe "enemies" do
    alias DndTracker.Encounters.Enemy

    import DndTracker.EncountersFixtures

    @invalid_attrs %{name: nil}

    test "list_enemies/0 returns all enemies", %{campaign: campaign} do
      enemy = enemy_fixture(campaign)
      assert Encounters.list_enemies(campaign) == [enemy]
    end

    test "get_enemy!/1 returns the enemy with given id", %{campaign: campaign} do
      enemy = enemy_fixture(campaign)
      assert Encounters.get_enemy!(enemy.id) == enemy
    end

    test "create_enemy/1 with valid data creates a enemy", %{campaign: campaign} do
      assert {:ok, %Enemy{}} = Encounters.create_enemy(campaign, @valid_attrs)
    end

    test "create_enemy/1 with invalid data returns error changeset", %{campaign: campaign} do
      assert {:error, %Ecto.Changeset{}} = Encounters.create_enemy(campaign, @invalid_attrs)
    end

    test "update_enemy/2 with valid data updates the enemy", %{campaign: campaign} do
      enemy = enemy_fixture(campaign)
      update_attrs = %{}

      assert {:ok, %Enemy{}} = Encounters.update_enemy(enemy, update_attrs)
    end

    test "update_enemy/2 with invalid data returns error changeset", %{campaign: campaign} do
      enemy = enemy_fixture(campaign)
      assert {:error, %Ecto.Changeset{}} = Encounters.update_enemy(enemy, @invalid_attrs)
      assert enemy == Encounters.get_enemy!(enemy.id)
    end

    test "delete_enemy/1 deletes the enemy", %{campaign: campaign} do
      enemy = enemy_fixture(campaign)
      assert {:ok, %Enemy{}} = Encounters.delete_enemy(enemy)
      assert_raise Ecto.NoResultsError, fn -> Encounters.get_enemy!(enemy.id) end
    end

    test "change_enemy/1 returns a enemy changeset", %{campaign: campaign} do
      enemy = enemy_fixture(campaign)
      assert %Ecto.Changeset{} = Encounters.change_enemy(enemy)
    end
  end
end
