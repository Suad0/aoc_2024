defmodule PlaygroundElixir.DayFour do
  def solve(filename \\ "/Users/suad/ProjektePrivate/playground_elixir/input.txt") do
    grid =
      filename
      |> File.read!()
      |> String.trim()
      |> String.split("\n")

    rows = length(grid)
    cols = String.length(Enum.at(grid, 0))

    patterns = [
      %{
        chars: "XMAS",
        directions: [
          {0, 1},
          {1, 0},
          {1, 1},
          {0, -1},
          {-1, 0},
          {-1, 1}
        ]
      },
      %{
        chars: "SMAX",
        directions: [
          {0, 1},
          {1, 0},
          {1, 1},
          {-1, 1}
        ]
      },
      %{chars: "MAS", check_p2: true}
    ]

    for r <- 0..(rows - 1),
        c <- 0..(cols - 1),
        pattern <- patterns,
        reduce: {0, 0} do
      {p1, p2} ->
        p1 =
          if Map.has_key?(pattern, :directions) do
            p1 +
              Enum.count(pattern.directions, fn {dr, dc} ->
                check_pattern(grid, r, c, pattern.chars, dr, dc)
              end)
          else
            p1
          end

        p2 =
          if Map.get(pattern, :check_p2, false) and r + 2 < rows and c + 2 < cols do
            if check_p2_patterns(grid, r, c), do: p2 + 1, else: p2
          else
            p2
          end

        {p1, p2}
    end
  end

  defp is_valid?(grid, r, c) do
    rows = length(grid)
    cols = String.length(Enum.at(grid, 0))
    r >= 0 and r < rows and c >= 0 and c < cols
  end

  defp check_pattern(grid, r, c, chars, dr, dc) do
    chars
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.all?(fn {char, i} ->
      nr = r + dr * i
      nc = c + dc * i
      is_valid?(grid, nr, nc) and String.at(Enum.at(grid, nr), nc) == char
    end)
  end

  defp check_p2_patterns(grid, r, c) do
    cond do
      String.at(Enum.at(grid, r), c) == "M" and
        String.at(Enum.at(grid, r + 1), c + 1) == "A" and
        String.at(Enum.at(grid, r + 2), c + 2) == "S" and
          ((String.at(Enum.at(grid, r + 2), c) == "M" and
              String.at(Enum.at(grid, r), c + 2) == "S") or
             (String.at(Enum.at(grid, r + 2), c) == "S" and
                String.at(Enum.at(grid, r), c + 2) == "M")) ->
        true

      String.at(Enum.at(grid, r), c) == "S" and
        String.at(Enum.at(grid, r + 1), c + 1) == "A" and
        String.at(Enum.at(grid, r + 2), c + 2) == "M" and
          ((String.at(Enum.at(grid, r + 2), c) == "M" and
              String.at(Enum.at(grid, r), c + 2) == "S") or
             (String.at(Enum.at(grid, r + 2), c) == "S" and
                String.at(Enum.at(grid, r), c + 2) == "M")) ->
        true

      true ->
        false
    end
  end

  def run do
    {p1, p2} = solve()
    IO.puts(p1)
    IO.puts(p2)
  end
end
