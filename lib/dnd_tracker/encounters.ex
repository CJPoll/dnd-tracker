defmodule DndTracker.Encounters do
  require DndTracker.Encounters.Thresholds

  alias DndTracker.Encounters.Enemies
  alias DndTracker.Encounters.Thresholds
  alias DndTracker.Encounters.XP
  alias DndTracker.Likelihood

  @type level :: integer()
  @type count :: integer()
  @type party_composition :: %{level() => count()}
  @type xp :: integer()
  @type encounter_spread :: :single | :split | :boss_with_minions

  @type difficulty :: :easy | :medium | :hard | :deadly

  @spec generate(party_composition() | xp(), difficulty()) :: any()
  def generate(party_composition, difficulty, opts \\ [])
      when is_map(party_composition) and Thresholds.difficulty?(difficulty) do
    budget = xp_budget(party_composition, difficulty) |> IO.inspect(label: "XP Budget")

    encounter_spread = Keyword.get(opts, :encounter_spread, nil)

    encounter_spread = encounter_spread || encounter_spread()

    case encounter_spread do
      :single ->
        budget
        |> level_for_budget
        |> generate_single

      :split ->
        generate_split(budget)

      :boss_with_minions ->
        :ok
    end
  end

  def average_party_level(party_composition) do
    div(party_level_sum(party_composition), party_count(party_composition))
  end

  def party_level_sum(party_composition) do
    Enum.reduce(party_composition, 0, fn {level, count}, acc -> level * count + acc end)
  end

  @doc """
  Returns the total number of characters in the party.
  """
  @spec party_count(party_composition()) :: integer
  def party_count(party_composition) do
    party_composition
    |> Map.values()
    |> Enum.reduce(0, &Kernel.+/2)
  end

  @spec xp_budget(party_composition(), difficulty()) :: xp()
  def xp_budget(party_composition, difficulty) do
    Enum.reduce(party_composition, 0, fn
      {level, count}, acc ->
        xp = Thresholds.threshold(level, difficulty) * count
        xp + acc
    end)
  end

  @spec encounter_spread() :: encounter_spread()
  def encounter_spread do
    Likelihood.new()
    |> Likelihood.chance(2, :single)
    # Change to 2 when implemented
    |> Likelihood.chance(1, :split)
    # Change to 1 when implemented
    |> Likelihood.chance(0, :boss_with_minions)
    |> Likelihood.outcome()
  end

  def generate_single(level) do
    Enemies.generate(level)
  end

  def generate_split(budget) do
    enemy_count = split_encounter_count() |> IO.inspect(label: "Enemy Count")

    encounter_multiplier =
      Thresholds.encounter_multiplier(enemy_count) |> IO.inspect(label: "Encounter Multiplier")

    budget =
      round(budget / encounter_multiplier) |> IO.inspect(label: "Adjusted Encounter Budget")

    budget_per_enemy = div(budget, enemy_count) |> IO.inspect(label: "Budget Per Enemy")
    level = level_for_budget(budget_per_enemy) |> IO.inspect(label: "Level for Budget per enemy")

    Enum.map(1..enemy_count, fn _ -> Enemies.generate(level) end)
  end

  def split_encounter_count do
    Likelihood.new()
    |> Likelihood.chance(6, 2)
    |> Likelihood.chance(4, 3)
    |> Likelihood.chance(2, 4)
    |> Likelihood.chance(1, 5)
    |> Likelihood.chance(1, 6)
    |> Likelihood.chance(1, 7)
    |> Likelihood.outcome()
  end

  def level_for_budget(budget) do
    value =
      XP.values()
      |> Enum.sort(fn {_level1, xp1}, {_level2, xp2} -> xp1 >= xp2 end)
      |> Enum.find(fn {_level, xp} -> xp <= budget end)

    case value do
      {level, _xp} -> level
      nil -> 1
    end
  end
end
