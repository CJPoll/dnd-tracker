defmodule DndTracker.Campaigns.Campaign do
  use Ecto.Schema

  import Ecto
  import Ecto.Changeset
  import Ecto.Query

  alias DndTracker.Campaigns.Player
  alias DndTracker.Encounters.Enemy

  schema "campaigns" do
    field :name, :string

    has_many :players, Player
    has_many :enemies, Enemy

    timestamps()
  end

  @doc false
  def changeset(campaign, attrs) do
    campaign
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def add_player_changeset(campaign) do
    build_assoc(campaign, :players)
  end

  def add_enemy_changeset(campaign) do
    build_assoc(campaign, :enemies)
  end

  def join_players(queryable) do
    from c in queryable, preload: :players
  end

  def with_id(queryable, id) do
    from c in queryable,
      where: c.id == ^id
  end
end
