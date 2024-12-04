defmodule PlaygroundElixir.DayTwo do
  def count_safe_reports_with_dampener(input) do
    input
    |> parse_input()
    |> Enum.count(&safe_with_dampener?/1)
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp valid_differences?(levels) do
    levels
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [a, b] -> abs(a - b) in 1..3 end)
  end

  defp monotonic?(levels) do
    increasing = Enum.chunk_every(levels, 2, 1, :discard) |> Enum.all?(fn [a, b] -> a < b end)
    decreasing = Enum.chunk_every(levels, 2, 1, :discard) |> Enum.all?(fn [a, b] -> a > b end)
    increasing or decreasing
  end

  defp safe?(levels) do
    valid_differences?(levels) and monotonic?(levels)
  end

  defp safe_with_dampener?(levels) do
    if safe?(levels) do
      true
    else
      Enum.any?(0..(length(levels) - 1), fn index ->
        modified_levels = List.delete_at(levels, index)
        safe?(modified_levels)
      end)
    end
  end
end
