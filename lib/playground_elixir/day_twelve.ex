defmodule PlaygroundElixir.DayTwelve do
  @directions [
    # up
    {-1, 0},
    # right
    {0, 1},
    # down
    {1, 0},
    # left
    {0, -1}
  ]

  def solve(filename) do
    grid =
      filename
      |> File.read!()
      |> String.trim()
      |> String.split("\n")

    {part1, part2} = calculate_region_metrics(grid)

    IO.puts("Part 1: #{part1}")
    IO.puts("Part 2: #{part2}")
  end

  def calculate_region_metrics(grid) do
    do_calculate_metrics(grid, 0, 0, MapSet.new())
  end

  defp do_calculate_metrics(grid, part1, part2, visited) do
    rows = length(grid)
    cols = String.length(Enum.at(grid, 0))

    Enum.reduce(0..(rows - 1), {part1, part2, visited}, fn r, {acc_p1, acc_p2, acc_visited} ->
      Enum.reduce(0..(cols - 1), {acc_p1, acc_p2, acc_visited}, fn c, {p1, p2, vis} ->
        key = coordinate_key({r, c})

        if MapSet.member?(vis, key) do
          {p1, p2, vis}
        else
          # Explore the region
          {area, perim, perim_cells, new_visited} = explore_region(grid, {r, c}, vis)

          # Count unique sides
          sides = count_sides(perim_cells)

          {p1 + area * perim, p2 + area * sides, new_visited}
        end
      end)
    end)
    |> then(fn {p1, p2, _} -> {p1, p2} end)
  end

  def explore_region(grid, start_coord, visited) do
    do_explore_region(grid, [start_coord], visited, start_coord, 0, 0, %{}, MapSet.new())
  end

  defp do_explore_region(grid, [], visited, _, area, perim, perim_cells, new_visited) do
    {area, perim, perim_cells, new_visited}
  end

  defp do_explore_region(
         grid,
         [current | queue],
         visited,
         start_coord,
         area,
         perim,
         perim_cells,
         new_visited
       ) do
    {r, c} = current
    start_value = grid |> Enum.at(r) |> String.at(c)
    key = coordinate_key(current)

    if MapSet.member?(visited, key) do
      do_explore_region(grid, queue, visited, start_coord, area, perim, perim_cells, new_visited)
    else
      new_visited = MapSet.put(new_visited, key)

      # Process neighbors
      {new_queue, new_area, new_perim, new_perim_cells} =
        Enum.reduce(@directions, {queue, area + 1, perim, perim_cells}, fn {dr, dc},
                                                                           {cur_queue, cur_area,
                                                                            cur_perim,
                                                                            cur_perim_cells} ->
          nr = r + dr
          nc = c + dc

          cond do
            # Within grid and same value
            nr >= 0 and nr < length(grid) and
              nc >= 0 and nc < String.length(Enum.at(grid, 0)) and
                grid |> Enum.at(nr) |> String.at(nc) == start_value ->
              {[{nr, nc} | cur_queue], cur_area, cur_perim, cur_perim_cells}

            # Perimeter cell
            true ->
              dir_key = coordinate_key({dr, dc})

              updated_perim_cells =
                Map.update(cur_perim_cells, dir_key, MapSet.new([key]), fn existing ->
                  MapSet.put(existing, key)
                end)

              {cur_queue, cur_area, cur_perim + 1, updated_perim_cells}
          end
        end)

      do_explore_region(
        grid,
        new_queue,
        visited,
        start_coord,
        new_area,
        new_perim,
        new_perim_cells,
        new_visited
      )
    end
  end

  def count_sides(perim_cells) do
    perim_cells
    |> Map.values()
    |> Enum.reduce(0, fn boundary, sides ->
      sides + count_boundary_sides(boundary)
    end)
  end

  defp count_boundary_sides(boundary) do
    boundary
    |> MapSet.to_list()
    |> Enum.reduce(0, fn cell, sides ->
      if sides > 0, do: sides, else: 1
    end)
  end

  defp coordinate_key({x, y}), do: "#{x},#{y}"
end
