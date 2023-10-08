defmodule DndTracker.Encounters.EnemyPlan do
  alias DndTracker.Encounters.{AC, HP, Level}

  defstruct [
    :defensive_variance,
    :high_defensive_trait,
    :high_offensive_trait,
    :high_trait,
    :offensive_variance,
    :overall_level,
    :variance
  ]

  def defensive(%Level{} = level) do
    variance =
      case Level.variance(level) do
        0 -> 1
        other -> other
      end

    new(level, variance, :defense)
  end

  def offensive(%Level{} = level) do
    variance =
      case Level.variance(level) do
        0 -> 1
        other -> other
      end

    new(level, variance, :offense)
  end

  def new(%Level{} = level) do
    variance = Level.variance(level)
    high_trait = high_trait()

    new(level, variance, high_trait)
  end

  defp new(%Level{} = level, variance, high_trait) do
    %__MODULE__{
      overall_level: level,
      high_trait: high_trait,
      high_defensive_trait: high_defensive_trait(),
      high_offensive_trait: high_offensive_trait(),
      variance: variance,
      defensive_variance: level |> defensive_level(high_trait, variance) |> Level.variance(),
      offensive_variance: level |> offensive_level(high_trait, variance) |> Level.variance()
    }
  end

  def defensive_level(%__MODULE__{
        overall_level: level,
        high_trait: high_trait,
        variance: variance
      }) do
    defensive_level(level, high_trait, variance)
  end

  def offensive_level(%__MODULE__{
        overall_level: level,
        high_trait: high_trait,
        variance: variance
      }) do
    offensive_level(level, high_trait, variance)
  end

  def ac(%__MODULE__{defensive_variance: variance, high_defensive_trait: :ac} = plan) do
    plan
    |> defensive_level
    |> Level.increment(variance)
    |> AC.for_level()
  end

  def ac(%__MODULE__{defensive_variance: variance, high_defensive_trait: :hp} = plan) do
    plan
    |> defensive_level
    |> Level.decrement(variance)
    |> AC.for_level()
  end

  def hp(%__MODULE__{defensive_variance: variance, high_defensive_trait: :ac} = plan) do
    plan
    |> defensive_level
    |> Level.decrement(variance)
    |> HP.for_level()
  end

  def hp(%__MODULE__{defensive_variance: variance, high_defensive_trait: :hp} = plan) do
    plan
    |> defensive_level
    |> Level.increment(variance)
    |> HP.for_level()
  end

  defp high_trait do
    case :rand.uniform(2) do
      1 -> :defense
      2 -> :offense
    end
  end

  defp high_defensive_trait do
    case :rand.uniform(2) do
      1 -> :ac
      2 -> :hp
    end
  end

  defp high_offensive_trait do
    case :rand.uniform(2) do
      1 -> :damage
      2 -> :attack
    end
  end

  defp defensive_level(%Level{} = overall_level, :defense, variance) do
    Level.increment(overall_level, variance)
  end

  defp defensive_level(%Level{} = overall_level, :offense, variance) do
    Level.decrement(overall_level, variance)
  end

  defp offensive_level(%Level{} = overall_level, :offense, variance) do
    Level.increment(overall_level, variance)
  end

  defp offensive_level(%Level{} = overall_level, :defense, variance) do
    Level.decrement(overall_level, variance)
  end
end
