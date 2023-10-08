defmodule DndTracker.Encounters.Enemy do
  use Ecto.Schema

  import Ecto.Changeset

  alias DndTracker.Campaigns.Campaign
  alias DndTracker.Encounters.Enemy.Attack
  alias DndTracker.Encounters.{AC, Dice, EnemyPlan, HP, Level}
  alias DndTracker.Likelihood

  @derive {Inspect, only: [:ac, :attacks, :hp]}

  schema "enemies" do
    field :name, :string
    field :description, :string
    field :ac, :integer
    has_many :attacks, Attack
    belongs_to :hp, Dice
    belongs_to :campaign, Campaign

    timestamps()
  end

  # defstruct [:ac, :hp, attacks: []]

  def new(level) when is_integer(level) do
    level
    |> Level.new()
    |> new
  end

  def new(%Level{} = level) do
    level
    |> EnemyPlan.new()
    |> new
  end

  def new(%EnemyPlan{overall_level: level, high_offensive_trait: offense_trait} = plan) do
    attack_count = attack_count()

    %__MODULE__{
      ac: EnemyPlan.ac(plan),
      # hp: EnemyPlan.hp(plan),
      attacks:
        Enum.map(1..attack_count, fn
          1 ->
            plan
            |> EnemyPlan.offensive_level()
            |> Attack.new(offense_trait)

          _ ->
            level
            |> varied_attack_level
            |> Attack.new(offense_trait)
        end),
      hp: plan |> EnemyPlan.hp() |> Enum.random() |> Dice.with_average()
    }
  end

  def challenge_rating(%__MODULE__{} = enemy) do
    defensive_level = defensive_level(enemy).level
    offensive_level = offensive_level(enemy).level

    ceil((defensive_level + offensive_level) / 2)
  end

  def defensive_level(%__MODULE__{ac: ac} = enemy) do
    # HP level spread is non-overlapping
    hp_level = hp_level(enemy)
    expected_ac = AC.for_level(hp_level)

    level_modifier = trunc((ac - expected_ac) / 2)

    Level.new(hp_level + level_modifier)
  end

  def hp_level(%__MODULE__{hp: %Dice{} = hp}) do
    hp_average = Dice.average(hp)
    [hp_level] = HP.levels_for(hp_average)
    hp_level
  end

  def offensive_level(%__MODULE__{attacks: attacks}) do
    attacks
    |> Attack.highest_attack()
    |> Attack.level()
  end

  defp attack_count do
    # 20% chance the monster will have 1 attack
    # 50% chance the monster will have 2 attacks
    # 30% chance the monster will have 3 attacks
    Likelihood.new()
    |> Likelihood.chance(3, 3)
    |> Likelihood.chance(5, 2)
    |> Likelihood.chance(2, 1)

    case :rand.uniform(10) do
      n when n <= 2 -> 3
      n when n <= 8 -> 2
      _ -> 1
    end
  end

  defp varied_attack_level(level) do
    variance = Level.variance(level)

    Level.decrement(level, variance)
  end

  def changeset(data, params) do
    data
    |> cast(params, [:name, :description, :ac, :campaign_id])
    |> cast_assoc(:attacks)
    |> cast_assoc(:hp)
    |> validate_required([:name, :ac, :campaign_id])
    |> foreign_key_constraint(:campaign_id)
    |> foreign_key_constraint(:hp)
  end

  def to_params(%__MODULE__{} = enemy) do
    %{
      name: enemy.name,
      description: enemy.description,
      ac: enemy.ac,
      hp: Dice.to_params(enemy.hp),
      attacks: Enum.map(enemy.attacks, &Attack.to_params/1)
    }
  end
end
