defmodule DndTracker.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :name, :string
      add :campaign_id, references(:campaigns, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:players, [:campaign_id])
  end
end
