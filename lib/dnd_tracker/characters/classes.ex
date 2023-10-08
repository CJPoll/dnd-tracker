defmodule DndTracker.Characters.Classes do
  alias DndTracker.Characters.Class

  defdelegate display_name(class), to: Class
  defdelegate hit_die(class), to: Class
end
