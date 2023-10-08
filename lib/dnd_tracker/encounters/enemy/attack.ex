defmodule DndTracker.Encounters.Enemy.Attack do
  use Ecto.Schema

  import Ecto.Changeset

  alias DndTracker.Encounters.{AttackBonus, Damage, Dice, Enemy, Level, Save}
  alias DndTracker.Likelihood

  @derive {Inspect,
           only: [
             :attack_bonus,
             :damage,
             :damage_type,
             :level,
             :range,
             :save,
             :save_effect
           ]}

  @damage_types [
    :slashing,
    :piercing,
    :bludgeoning,
    :acid,
    :cold,
    :fire,
    :force,
    :lightning,
    :necrotic,
    :poison,
    :psychic,
    :radiant,
    :thunder
  ]

  def damage_types do
    @damage_types
  end

  schema "attacks" do
    field :name, :string
    field :description, :string
    field :range, :integer
    field :attack_bonus, :integer
    field :save, :integer
    field :save_effect, :string
    field :damage_type, Ecto.Enum, values: @damage_types
    field :level, :integer, virtual: true

    belongs_to :damage, Dice
    belongs_to :enemy, Enemy

    timestamps()
  end

  def changeset(data, params) do
    data
    |> cast(params, [
      :name,
      :description,
      :range,
      :attack_bonus,
      :save,
      :save_effect,
      :damage_type,
      :level
    ])
    |> cast_assoc(:damage)
    |> validate_required([:name, :range, :attack_bonus, :damage_type])
  end

  def new(%Level{} = level, high_trait \\ Enum.random([:attack, :damage])) do
    variance = Level.variance(level)
    damage_level = adjust_damage(level, variance, high_trait)

    save_level =
      if high_trait == :attack do
        Level.increment(level, 2 * variance)
      else
        Level.decrement(level, 2 * variance)
      end

    save = Save.for_level(save_level)

    damage =
      damage_level
      |> Damage.for_level()
      |> Enum.random()
      |> Dice.with_average()

    expected_attack_bonus = AttackBonus.for_level(damage_level)

    attack_bonus =
      if high_trait == :attack do
        expected_attack_bonus + 2 * variance
      else
        expected_attack_bonus - 2 * variance
      end

    %__MODULE__{
      range: range(),
      damage: damage,
      attack_bonus: attack_bonus,
      save: save,
      damage_type: damage_type(),
      level: level(damage, attack_bonus)
    }
  end

  def highest_attack(attacks) do
    Enum.reduce(attacks, fn attack, highest ->
      if attack.damage |> Dice.average() > highest.damage |> Dice.average(),
        do: attack,
        else: highest
    end)
  end

  def level(%__MODULE__{level: level}) when not is_nil(level), do: level

  def level(%__MODULE__{} = attack) do
    level(attack.damage, attack.attack_bonus)
  end

  def damage_level(%__MODULE__{damage: damage_dice}) do
    damage_level(damage_dice)
  end

  def damage_level(%Dice{} = damage_dice) do
    [damage_level] =
      damage_dice
      |> Dice.average()
      |> Damage.levels_for()

    damage_level
  end

  def level(damage, attack_bonus) do
    damage_level = damage_level(damage)

    expected_attack_bonus = AttackBonus.for_level(damage_level)

    level_modifier = trunc((attack_bonus - expected_attack_bonus) / 2)

    level = damage_level + level_modifier

    level =
      if level > 1 do
        trunc(level)
      else
        level
      end

    Level.new(level)
  end

  defp range do
    Likelihood.new()
    |> Likelihood.chance(50, 5)
    |> Likelihood.chance(10, 10)
    |> Likelihood.chance(10, 20)
    |> Likelihood.chance(5, 25)
    |> Likelihood.chance(5, 30)
    |> Likelihood.chance(5, 35)
    |> Likelihood.chance(5, 40)
    |> Likelihood.chance(5, 45)
    |> Likelihood.chance(5, 50)
    |> Likelihood.outcome()
  end

  # defp high_trait do
  #   case :rand.uniform(2) do
  #     1 -> :attack
  #     2 -> :damage
  #   end
  # end

  defp adjust_damage(%Level{} = level, variance, :attack) do
    Level.decrement(level, variance)
  end

  defp adjust_damage(%Level{} = level, variance, :damage) do
    Level.increment(level, variance)
  end

  defp damage_type do
    if elemental?() do
      Likelihood.new()
      |> Likelihood.chance(5, :acid)
      |> Likelihood.chance(5, :cold)
      |> Likelihood.chance(5, :fire)
      |> Likelihood.chance(7, :force)
      |> Likelihood.chance(5, :lightning)
      |> Likelihood.chance(6, :necrotic)
      |> Likelihood.chance(9, :poison)
      |> Likelihood.chance(6, :psychic)
      |> Likelihood.chance(4, :radiant)
      |> Likelihood.chance(7, :thunder)
      |> Likelihood.outcome()
    else
      Likelihood.new()
      |> Likelihood.chance(1, :slashing)
      |> Likelihood.chance(1, :piercing)
      |> Likelihood.chance(1, :bludgeoning)
      |> Likelihood.outcome()
    end
  end

  defp elemental? do
    Likelihood.new()
    |> Likelihood.chance(65, false)
    |> Likelihood.chance(35, true)
    |> Likelihood.outcome()
  end

  def to_params(%__MODULE__{} = attack) do
    %{
      name: attack.name,
      description: attack.description,
      range: attack.range,
      attack_bonus: attack.attack_bonus,
      save: attack.save,
      save_effect: attack.save_effect,
      damage_type: attack.damage_type,
      level: attack.level.level,
      damage: Dice.to_params(attack.damage),
      enemy_id: attack.enemy_id
    }
  end
end
