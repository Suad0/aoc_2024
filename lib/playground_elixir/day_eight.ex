defmodule PlaygroundElixir.DayEight do
  def solve(input_file) do
    grid =
      input_file
      |> File.read!()
      |> String.trim()
      |> String.split("\n")

    # Grid dimensions
    rows = length(grid)
    cols = String.length(Enum.at(grid, 0))

    positions =
      grid
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, r} ->
        row
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.filter(fn {char, _} -> char != "." end)
        |> Enum.map(fn {char, c} -> {char, r * cols + c} end)
      end)
      |> Enum.group_by(fn {char, _} -> char end, fn {_, pos} -> pos end)

    {part1, part2} = solve_antennas(positions, rows, cols)

    %{part1: part1, part2: part2}
  end

  def solve_antennas(positions, rows, cols) do
    positions
    |> Enum.reduce({MapSet.new(), MapSet.new()}, fn {_, freq_positions}, {acc1, acc2} ->
      if length(freq_positions) < 2 do
        {acc1, acc2}
      else
        freq_positions
        |> combinations()
        |> Enum.reduce({acc1, acc2}, fn [p1, p2], {a1, a2} ->
          {r1, c1} = {div(p1, cols), rem(p1, cols)}
          {r2, c2} = {div(p2, cols), rem(p2, cols)}

          dx = c2 - c1
          dy = r2 - r1

          new_points =
            for r <- 0..(rows - 1),
                c <- 0..(cols - 1),
                dx * (r - r1) == dy * (c - c1) do
              # Calculate Manhattan distances
              d1 = abs(r - r1) + abs(c - c1)
              d2 = abs(r - r2) + abs(c - c2)

              point = r * cols + c

              # Part 1: Specific distance ratio
              a1 = if d1 == 2 * d2 or d1 * 2 == d2, do: MapSet.put(a1, point), else: a1

              # Part 2: Any collinear point
              a2 = MapSet.put(a2, point)

              {a1, a2}
            end

          Enum.reduce(new_points, {a1, a2}, fn {na1, na2}, {a1, a2} ->
            {MapSet.union(a1, na1), MapSet.union(a2, na2)}
          end)
        end)
      end
    end)
    |> then(fn {a1, a2} -> {MapSet.size(a1), MapSet.size(a2)} end)
  end

  def combinations(list) do
    for i <- 0..(length(list) - 2),
        j <- (i + 1)..(length(list) - 1) do
      [Enum.at(list, i), Enum.at(list, j)]
    end
  end

  def main(args \\ []) do
    input_file = List.first(args) || "/Users/suad/ProjektePrivate/playground_elixir/input.txt"

    result = solve(input_file)
    IO.puts("Part 1: #{result.part1}")
    IO.puts("Part 2: #{result.part2}")
    result
  end
end
