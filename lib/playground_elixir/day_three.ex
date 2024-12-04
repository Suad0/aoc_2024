defmodule PlaygroundElixir.DayThree do
  def extract_and_sum_mul_with_conditions(input) do
    regex = ~r/(do\(\)|don't\(\)|mul\((\d{1,3}),\s*(\d{1,3})\))/

    input
    |> Regex.scan(regex, capture: :all_but_first)
    |> process_instructions(true, 0)
  end

  defp process_instructions([], _is_enabled, total), do: total

  defp process_instructions([["do()"] | rest], _is_enabled, total) do
    process_instructions(rest, true, total)
  end

  defp process_instructions([["don't()"] | rest], _is_enabled, total) do
    process_instructions(rest, false, total)
  end

  defp process_instructions([["mul", x, y] | rest], true, total) do
    result = String.to_integer(x) * String.to_integer(y)
    process_instructions(rest, true, total + result)
  end

  defp process_instructions([["mul", _x, _y] | rest], false, total) do
    process_instructions(rest, false, total)
  end
end
