defmodule DndTracker.Log do
  @var_indicators [nil, Elixir]

  defmacro __using__(_) do
    quote do
      alias unquote(__MODULE__)
      require unquote(__MODULE__)
    end
  end

  defmacro inspect({_var_name, _meta, var_indicator} = ast)
           when var_indicator in @var_indicators do
    label = extract_label(__CALLER__.module, __ENV__.line, ast)

    quote do
      IO.inspect(unquote(ast), label: unquote(label), limit: 1000, printable_limit: 4096 * 4)
    end
  end

  defmacro inspect(ast) do
    label = extract_label(__CALLER__.module, __ENV__.line, ast)

    quote do
      IO.inspect(unquote(ast), label: unquote(label), limit: 1000, printable_limit: 4096 * 4)
    end
  end

  def extract_label(calling_module, line_number, {var_name, _meta, indicator})
      when indicator in @var_indicators do
    label(calling_module, line_number, var_name)
  end

  def extract_label(calling_module, line_number, other) do
    label(calling_module, line_number, other)
  end

  defp label(calling_module, line_number, rest) do
    case line_number do
      nil ->
        "#{Kernel.inspect(calling_module)} #{rest}"

      line_number ->
        "#{Kernel.inspect(calling_module)}:#{line_number} #{rest}"
    end
  end

  def line_number({_, meta, _}) do
    Keyword.get(meta, :line, nil)
  end

  # defp append_rest(label, nil), do: label
  # defp append_rest(label, ""), do: label
  # defp append_rest(label, rest), do: label <> " " <> rest
end
