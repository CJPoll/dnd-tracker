defmodule DndTracker.Constants do
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
    end
  end

  defmacro constant(name, value) do
    Module.register_attribute(__CALLER__.module, name, [])
    Module.put_attribute(__CALLER__.module, name, value)

    func =
      quote do
        def unquote(name)() do
          unquote(value)
        end
      end

    guard =
      if is_list(value) do
        quote do
          Kernel.defguard(unquote(:"#{name}?")(value) when value in unquote(value))
        end
      else
        quote do
          Kernel.defguard(unquote(:"#{name}?")(value) when value == unquote(value))
        end
      end

    {:__block__, [],
     [
       func,
       guard
     ]}
  end
end
