defmodule DndTracker.Entity do
  alias Ecto.UUID
  alias DndTracker.Entity.Component

  defstruct [:id, components: %{}]

  def new do
    %__MODULE__{id: UUID.generate()}
  end

  def has_component?(%__MODULE__{components: components}, name) do
    Map.has_key?(components, name)
  end

  def add_component(%__MODULE__{components: components} = entity, component) do
    name = Component.name(component)
    components = Map.update(components, name, component, fn _ -> component end)
    %__MODULE__{entity | components: components}
  end

  def get_component(%__MODULE__{components: components}, name) do
    Map.get(components, name)
  end
end
