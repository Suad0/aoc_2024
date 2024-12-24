defmodule Day16 do
  defmodule NodePartTwo do
    defstruct x: 0, y: 0, dir: 0, score: 0
  end

  """

  defmodule PriorityQueue do
    defstruct queue: []

    def new(), do: %PriorityQueue{}

    def push(%PriorityQueue{queue: queue} = pq, item) do
      %PriorityQueue{pq | queue: :lists.sort([item | queue], &(&1.score < &2.score))}
    end

    def pop(%PriorityQueue{queue: [head | tail]}) do
      {head, %PriorityQueue{queue: tail}}
    end

    def empty?(%PriorityQueue{queue: []}), do: true
    def empty?(_), do: false
  end

  def read_maze(file_path) do
    file_path
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_charlist/1)
  end

  def find_start_end(maze) do
    Enum.reduce(maze, {nil, nil}, fn row, {start, ende} ->
      Enum.reduce(row, {start, ende}, fn
        ?S, {nil, ende} -> {row_index, col_index}
        ?E, {start, nil} -> {start, {row_index, col_index}}
        _, acc -> acc
      end)
    end)
  end

  def reindeer_maze_part_two(file_path) do
    maze = read_maze(file_path)
    {start, end} = find_start_end(maze)

    moves = [{-1, 0}, {0, 1}, {1, 0}, {0, -1}]
    pq = PriorityQueue.new()
    dist = %{}
    best = :infinity
    first_pass = true

    pq = PriorityQueue.push(pq, %NodePartTwo{x: elem(start, 0), y: elem(start, 1), dir: 1, score: 0})

    while not PriorityQueue.empty?(pq) do
      {current, pq} = PriorityQueue.pop(pq)
      key = "{current.x},{current.y},{current.dir}"

      if Map.has_key?(dist, key), do: continue

      dist = Map.put(dist, key, current.score)

      if {current.x, current.y} == end do
        if first_pass do
          best = current.score
          first_pass = false
        end
        continue
      end

      # Move forward
      {dx, dy} = Enum.at(moves, current.dir)
      nx = current.x + dx
      ny = current.y + dy

      if valid_move?(nx, ny, maze) do
        pq = PriorityQueue.push(pq, %NodePartTwo{x: nx, y: ny, dir: current.dir, score: current.score + 1})
      end

      # Rotate clockwise and counterclockwise
      pq = PriorityQueue.push(pq, %NodePartTwo{x: current.x, y: current.y, dir: rem(current.dir + 1, 4), score: current.score + 1000})
      pq = PriorityQueue.push(pq, %NodePartTwo{x: current.x, y: current.y, dir: rem(current.dir + 3, 4), score: current.score + 1000})
    end

    # Second BFS: Backward traversal from the end
    dist2 = %{}
    pq = PriorityQueue.new()

    for dir <- 0..3 do
      pq = PriorityQueue.push(pq, %NodePartTwo{x: elem(end, 0), y: elem(end, 1), dir: dir, score: 0})
    end

    while not PriorityQueue.empty?(pq) do
      {current, pq} = PriorityQueue.pop(pq)
      key = "{current.x},{current.y},{current.dir}"

      if Map.has_key?(dist2, key), do: continue

      dist2 = Map.put(dist2, key, current.score)

      # Move backward
      {dx, dy} = Enum.at(moves, rem(current.dir + 2, 4))
      nx = current.x + dx
      ny = current.y + dy

      if valid_move?(nx, ny, maze) do
        pq = PriorityQueue.push(pq, %NodePartTwo{x: nx, y: ny, dir: current.dir, score: current.score + 1})
      end

      # Rotate clockwise and counterclockwise
      pq = PriorityQueue.push(pq, %NodePartTwo{x: current.x, y: current.y, dir: rem(current.dir + 1, 4), score: current.score + 1000})
      pq = PriorityQueue.push(pq, %NodePartTwo{x: current.x, y: current.y, dir: rem(current.dir + 3, 4), score: current.score + 1000})
    end

    # Determine valid tiles
    optimal_tiles = %{}
    for r <- 0..(length(maze) - 1) do
      for c <- 0..(length(hd(maze)) - 1) do
        for dir <- 0..3 do
          key = "{r},{c},{dir}"
          if Map.has_key?(dist, key) and Map.has_key?(dist2, key) do
            if dist[key] + dist2[key] == best do
              optimal_tiles = Map.put(optimal_tiles, {r, c}, true)
            end
          end
        end
      end
    end

    map_size(optimal_tiles)
  end

  defp valid_move?(x, y, maze) do
    x >= 0 and y >= 0 and x < length(maze) and y < length(hd(maze)) and Enum.at(Enum.at(maze, x), y) != ?#
  end

  def run_day_16_part_two do
    file_path = "input.txt"
    result = reindeer_maze_part_two(file_path)
    IO.puts(result)
  end

  """
end
