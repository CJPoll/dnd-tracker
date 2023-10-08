defmodule DndTracker.Characters.Character.Macros do
  defmacro ability(ability) do
    quote do
      alias DndTracker.Characters.{Abilities, Races}

      def unquote(:"#{ability}")(%__MODULE__{
            abilities: %Abilities{strength: base_ability_score},
            race: race
          }) do
        racial_ability_bonus = Races.ability_bonus(race, unquote(ability))

        base_ability_score + racial_ability_bonus
      end

      def unquote(:"#{ability}_bonus")(
            %__MODULE__{
              abilities: %Abilities{strength: base_ability_score},
              race: race
            } = character
          ) do
        ability = unquote(ability)(character)
        racial_ability_bonus = Races.ability_bonus(race, unquote(ability))

        ability_score = base_ability_score + racial_ability_bonus

        ability_bonus(ability_score)
      end
    end
  end
end

defmodule DndTracker.Characters.Character do
  import DndTracker.Characters.Character.Macros
  alias DndTracker.Characters.Abilities

  defstruct [:alignment, :class, :name, :race, abilities: Abilities.new(), level: 1, xp: 0]

  def new, do: %__MODULE__{}

  def add_xp(%__MODULE__{xp: xp} = character, amount) do
    %__MODULE__{character | xp: xp + amount}
  end

  def class(%__MODULE__{} = character, class) do
    %__MODULE__{character | class: class}
  end

  def race(%__MODULE__{} = character, race) do
    %__MODULE__{character | race: race}
  end

  ability(:strength)
  ability(:dexterity)
  ability(:constitution)
  ability(:intelligence)
  ability(:wisdom)
  ability(:charisma)

  def race(%__MODULE__{race: race}), do: race

  def remove_xp(%__MODULE__{xp: xp} = character, amount) do
    %__MODULE__{character | xp: xp - amount}
  end

  defp ability_bonus(ability_score) when is_integer(ability_score) do
    trunc((ability_score - 10) / 2)
  end
end
