defmodule DndTrackerWeb.EnemyView do
  use DndTrackerWeb, :view

  alias DndTracker.Encounters.{AttackBonus, Dice, Enemy}
  alias DndTracker.Encounters.Enemy.Attack

  def attack_bonus(attack_bonus) do
    if attack_bonus >= 0 do
      "+#{attack_bonus}"
    else
      # Negative numbers already have a `-` included in the number
      attack_bonus
    end
  end
end
