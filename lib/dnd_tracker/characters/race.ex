defprotocol DndTracker.Characters.Race do
  def ability_score_modifiers(race)
  def base_speed(race)
  def languages(race)
  def proficiencies(race)
  def resistances(race)
  def saving_throw_advantages(race)
  def size(race)
  def vision(race)
  def weapon_proficiencies(race)
end
