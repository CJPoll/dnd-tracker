defmodule DndTracker.Repo.Migrations.CreateEnemies do
  use Ecto.Migration

  def change do
    create table(:dice) do
      add :average, :float, null: false
      add :count, :integer, default: 1
      add :value, :integer, null: false
      add :modifier, :integer, default: 0

      timestamps()
    end

    create table(:enemies) do
      add :name, :string, null: false
      add :description, :string
      add :ac, :integer, null: false

      add :hp_id, references(:dice, on_delete: :nothing), null: false
      add :campaign_id, references(:campaigns, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:enemies, [:campaign_id])

    create table(:attacks) do
      add :name, :string, null: false
      add :description, :string
      add :range, :integer, null: false
      add :attack_bonus, :integer, null: false
      add :damage_id, references(:dice, on_delete: :nothing), null: false
      add :save, :integer
      add :save_effect, :string
      add :damage_type, :string, null: false

      add :enemy_id, references(:enemies, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:attacks, [:enemy_id])
    create index(:attacks, [:damage_id])
  end
end
