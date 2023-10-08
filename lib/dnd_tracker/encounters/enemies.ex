defmodule DndTracker.Encounters.Enemies do
  import Ecto.Query
  import DndTracker.Constants

  alias DndTracker.Campaigns.Campaign
  alias DndTracker.Encounters.{Dice, Enemy, EnemyPlan, Level}
  alias DndTracker.Encounters.Enemy.Attack
  alias DndTracker.Repo

  constant(:monster_types, [:defensive, :offensive, :balanced])

  def generate(level, type \\ :balanced)

  def generate(level, type) when is_integer(level) or is_float(level) do
    level
    |> Level.new()
    |> generate(type)
  end

  def generate(%Level{} = level, :balanced) do
    enemy =
      level
      |> EnemyPlan.new()
      |> Enemy.new()

    enemy |> Enemy.defensive_level()
    enemy |> Enemy.offensive_level()

    enemy
  end

  def generate(%Level{} = level, :defensive) do
    level
    |> EnemyPlan.defensive()
    |> Enemy.new()
  end

  def generate(%Level{} = level, :offensive) do
    level
    |> EnemyPlan.offensive()
    |> Enemy.new()
  end

  def list_enemies(%Campaign{id: id}) do
    list_enemies(id)
  end

  def list_enemies(campaign_id) do
    q =
      from e in Enemy,
        left_join: c in Campaign,
        on: c.id == e.campaign_id,
        left_join: a in Attack,
        on: e.id == a.enemy_id,
        left_join: hp in Dice,
        on: hp.id == e.hp_id,
        left_join: d in Dice,
        on: d.id == a.damage_id,
        where: e.campaign_id == ^campaign_id,
        preload: [campaign: c, attacks: {a, damage: d}, hp: hp]

    Repo.all(q)
  end

  @doc """
  Gets a single enemy.

  Raises `Ecto.NoResultsError` if the Enemy does not exist.

  ## Examples

      iex> get_enemy!(123)
      %Enemy{}

      iex> get_enemy!(456)
      ** (Ecto.NoResultsError)

  """
  def get_enemy!(id) do
    q =
      from e in Enemy,
        left_join: c in Campaign,
        on: c.id == e.campaign_id,
        left_join: a in Attack,
        on: e.id == a.enemy_id,
        left_join: hp in Dice,
        on: hp.id == e.hp_id,
        left_join: d in Dice,
        on: d.id == a.damage_id,
        where: e.id == ^id,
        preload: [campaign: c, attacks: {a, damage: d}, hp: hp]

    Repo.one!(q)
  end

  @doc """
  Creates a enemy.

  ## Examples

      iex> create_enemy(%{field: value})
      {:ok, %Enemy{}}

      iex> create_enemy(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_enemy(campaign, attrs \\ %{}) do
    campaign
    |> Campaign.add_enemy_changeset()
    |> Enemy.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a enemy.

  ## Examples

      iex> update_enemy(enemy, %{field: new_value})
      {:ok, %Enemy{}}

      iex> update_enemy(enemy, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_enemy(%Enemy{} = enemy, attrs) do
    enemy
    |> Enemy.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a enemy.

  ## Examples

      iex> delete_enemy(enemy)
      {:ok, %Enemy{}}

      iex> delete_enemy(enemy)
      {:error, %Ecto.Changeset{}}

  """
  def delete_enemy(%Enemy{} = enemy) do
    Repo.delete(enemy)
  end

  def change_enemy(enemy, attrs \\ %{}) do
    Enemy.changeset(enemy, attrs)
  end
end
