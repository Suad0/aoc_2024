defmodule PlaygroundElixir.DaySix do
  def solve(filename) do
    {:ok, d} = File.read(filename)

    # Prepare grid
    g = String.trim(d) |> String.split("\n")
    r = length(g)
    c = String.length(Enum.at(g, 0))

    {sr, sc} = find_start(g)

    {p1, p2} = solve_grid(g, sr, sc, r, c)

    pr(p1)
    pr(p2)
  end

  def pr(s) do
    IO.puts(s)
  end

  def find_start(grid) do
    grid
    |> Enum.with_index()
    |> Enum.find_value(fn {row, r} ->
      case String.graphemes(row) |> Enum.with_index() |> Enum.find(fn {ch, _} -> ch == "^" end) do
        {_, sc} -> {r, sc}
        nil -> nil
      end
    end)
  end

  def solve_grid(g, sr, sc, r, c) do
    Enum.reduce(0..(r - 1), {0, 0}, fn o_r, {p1, p2} ->
      Enum.reduce(0..(c - 1), {p1, p2}, fn o_c, {curr_p1, curr_p2} ->
        # Skip the starting position
        if o_r == sr and o_c == sc do
          {curr_p1, curr_p2}
        else
          case run_path(g, sr, sc, o_r, o_c, r, c) do
            {:loop, _} -> {curr_p1, curr_p2 + 1}
            {:end, visited} -> {max(curr_p1, MapSet.size(visited)), curr_p2}
          end
        end
      end)
    end)
  end

  def run_path(g, sr, sc, o_r, o_c, r, c) do
    run_path_helper(g, sr, sc, o_r, o_c, r, c, sr, sc, 0, MapSet.new(), MapSet.new())
  end

  def run_path_helper(g, sr, sc, o_r, o_c, r, c, curr_r, curr_c, dir, seen, visited) do
    key = {curr_r, curr_c, dir}

    if MapSet.member?(seen, key) do
      {:loop, seen}
    else
      visited = MapSet.put(visited, {curr_r, curr_c})
      seen = MapSet.put(seen, key)

      directions = [{-1, 0}, {0, 1}, {1, 0}, {0, -1}]
      {dr, dc} = Enum.at(directions, dir)

      new_r = curr_r + dr
      new_c = curr_c + dc

      cond do
        new_r < 0 or new_r >= r or new_c < 0 or new_c >= c ->
          if get_char(g, o_r, o_c) == "#", do: {:end, visited}, else: {:end, visited}

        get_char(g, new_r, new_c) == "#" or (new_r == o_r and new_c == o_c) ->
          run_path_helper(
            g,
            sr,
            sc,
            o_r,
            o_c,
            r,
            c,
            curr_r,
            curr_c,
            rem(dir + 1, 4),
            seen,
            visited
          )

        true ->
          run_path_helper(g, sr, sc, o_r, o_c, r, c, new_r, new_c, dir, seen, visited)
      end
    end
  end

  def get_char(g, r, c) do
    g
    |> Enum.at(r)
    |> String.at(c)
  end
end
