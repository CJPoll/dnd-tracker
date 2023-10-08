alias DndTracker.Characters.Classes
alias DndTracker.Characters.Classes.Fighter
alias DndTracker.Characters.Races.{Dwarf, Elf}
alias DndTracker.Characters.{Character, Race}
alias DndTracker.Encounters
alias DndTracker.Encounters.Enemy.Attack
alias DndTracker.Encounters.{AC, AttackBonus, Damage, Dice, Enemy, HP, Level, EnemyPlan, Save}
alias DndTracker.{Campaigns, Likelihood}

alias DndTrackerWeb.Router.Helpers, as: Routes

:debugger.start()

IEx.configure(inspect: [charlists: :as_lists])
