defmodule DndTracker.StructHelpers do
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
    end
  end

  defmacro constructor do
    quote do
      def new do
        %__MODULE__{}
      end
    end
  end

  defmacro getter(field) when is_atom(field) do
    quote do
      def unquote(field)(%__MODULE__{unquote(field) => value}), do: value
    end
  end

  defmacro setter(field) when is_atom(field) do
    quote do
      def unquote(field)(%__MODULE__{} = struct, value) do
        %__MODULE__{struct | unquote(field) => value}
      end
    end
  end

  defmacro getters(fields) when is_list(fields) do
    for field <- fields do
      quote do
        unquote(__MODULE__).getter(unquote(field))
      end
    end
  end

  defmacro setters(fields) when is_list(fields) do
    for field <- fields do
      quote do
        unquote(__MODULE__).setter(unquote(field))
      end
    end
  end
end
