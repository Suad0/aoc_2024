defmodule PlaygroundElixir.DayTen do
  # Parses the input string into a 2D grid of integers
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
    end)
  end

  # Finds all trailheads (positions with height 0) in the grid
  def find_trailheads(grid) do
    for row <- 0..(length(grid) - 1),
        col <- 0..(length(Enum.at(grid, 0)) - 1),
        Enum.at(Enum.at(grid, row), col) == 0,
        do: {row, col}
  end

  # Recursive DFS to find distinct paths from the trailhead to height 9
  def dfs(grid, row, col, visited) do
    # Base case: If we reach height 9, its a valid trail endpoint
    if Enum.at(Enum.at(grid, row), col) == 9 do
      1
    else
      directions = [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]
      visited = MapSet.put(visited, {row, col})

      directions
      |> Enum.reduce(0, fn {dr, dc}, acc ->
        new_row = row + dr
        new_col = col + dc

        if valid_move?(grid, row, col, new_row, new_col, visited) do
          acc + dfs(grid, new_row, new_col, visited)
        else
          acc
        end
      end)
    end
  end

  # Validates the move
  defp valid_move?(grid, row, col, new_row, new_col, visited) do
    new_row >= 0 and new_row < length(grid) and
      new_col >= 0 and new_col < length(Enum.at(grid, 0)) and
      not MapSet.member?(visited, {new_row, new_col}) and
      Enum.at(Enum.at(grid, new_row), new_col) == Enum.at(Enum.at(grid, row), col) + 1
  end

  def calculate_trailhead_ratings(grid) do
    trailheads = find_trailheads(grid)

    trailheads
    |> Enum.reduce(0, fn {row, col}, acc ->
      visited = MapSet.new()
      acc + dfs(grid, row, col, visited)
    end)
  end

  def solve(input) do
    grid = parse_input(input)
    calculate_trailhead_ratings(grid)
  end
end
