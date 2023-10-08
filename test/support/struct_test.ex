defmodule DndTracker.StructTest do
  defmacro __using__(opts) do
    unless Keyword.has_key?(opts, :test_module) do
      raise "#{inspect(__CALLER__.module)} must pass in `test_module: SomeTestModule` in order to use #{
              __MODULE__
            }"
    end

    test_module = Keyword.get(opts, :test_module)

    quote do
      @__test_module__ unquote(test_module)
      import unquote(__MODULE__)
    end
  end

  defmacro defines_getter(field) do
    quote do
      test "defines getter for #{unquote(field)}" do
        assert function_exported?(@__test_module__, unquote(field), 1)
      end
    end
  end

  defmacro defines_setter(field) do
    quote do
      test "defines setter for #{unquote(field)}" do
        assert function_exported?(@__test_module__, unquote(field), 2)
      end
    end
  end

  defmacro defines_constructor do
    quote do
      test "defines a constructor" do
        assert function_exported?(@__test_module__, :new, 0)
      end
    end
  end
end
