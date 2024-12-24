defmodule PlaygroundElixir.Day19 do
  def can_form("", _patterns, _memo), do: true

  def can_form(design, patterns, memo) do
    case Map.get(memo, design) do
      nil ->
        result =
          Enum.any?(patterns, fn pattern ->
            String.starts_with?(design, pattern) &&
              can_form(String.slice(design, byte_size(pattern)..-1), patterns, memo)
          end)

        {result, Map.put(memo, design, result)}

      value ->
        {value, memo}
    end
  end

  def run_part1() do
    {patterns, designs} = read_input()

    {count, _} =
      Enum.reduce(designs, {0, %{}}, fn design, {count, memo} ->
        {can_form?, memo} = can_form(design, patterns, memo)

        if can_form? do
          {count + 1, memo}
        else
          {count, memo}
        end
      end)

    IO.puts("Number of possible designs: #{count}")
  end

  def count_ways("", _patterns, _memo), do: {1, %{}}

  def count_ways(design, patterns, memo) do
    case Map.get(memo, design) do
      nil ->
        {total_ways, memo} =
          Enum.reduce(patterns, {0, memo}, fn pattern, {acc, memo} ->
            if String.starts_with?(design, pattern) do
              {ways, updated_memo} =
                count_ways(String.slice(design, byte_size(pattern)..-1), patterns, memo)

              {acc + ways, updated_memo}
            else
              {acc, memo}
            end
          end)

        {total_ways, Map.put(memo, design, total_ways)}

      value ->
        {value, memo}
    end
  end

  def run_part2() do
    {patterns, designs} = read_input()

    {total, _} =
      Enum.reduce(designs, {0, %{}}, fn design, {acc, memo} ->
        {ways, memo} = count_ways(design, patterns, memo)
        {acc + ways, memo}
      end)

    IO.puts("Total number of ways: #{total}")
  end

  defp read_input() do
    {:ok, contents} = File.read("input.txt")

    [pattern_section | design_section] =
      contents
      |> String.split("\n\n", trim: true)
      |> Enum.map(&String.split(&1, "\n", trim: true))

    patterns = pattern_section |> List.first() |> String.split(", ")
    designs = Enum.concat(design_section)

    {patterns, designs}
  end
end
