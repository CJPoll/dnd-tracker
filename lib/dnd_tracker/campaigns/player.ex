defmodule DndTracker.Campaigns.Player do
  use Ecto.Schema
  import Ecto.Changeset

  alias DndTracker.Campaigns.Campaign

  schema "players" do
    field :name, :string
    belongs_to :campaign, Campaign

    timestamps()
  end

  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :campaign_id])
    |> validate_required([:name])
    |> foreign_key_constraint(:campaign_id)
  end
end
