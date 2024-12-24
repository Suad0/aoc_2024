defmodule Day13 do
  defmodule Machine do
    defstruct ax: 0, ay: 0, bx: 0, by: 0, px: 0, py: 0
  end

  # SolveMachine determines the minimum cost to win a prize for a single machine.
  # It returns the minimum cost or -1 if the prize cannot be won.
  def solve_machine(%Machine{ax: ax, ay: ay, bx: bx, by: by, px: px, py: py}) do
    min_cost = :infinity
    found = false

    for n_a <- 0..100 do
      for n_b <- 0..100 do
        # movements align with the prize location
        x = n_a * ax + n_b * bx
        y = n_a * ay + n_b * by

        if x == px and y == py do
          cost = n_a * 3 + n_b * 1

          if cost < min_cost do
            min_cost = cost
            found = true
          end
        end
      end
    end

    if found, do: min_cost, else: -1
  end

  def parse_input(input) do
    {machines, _} =
      String.split(input, "\n")
      |> Enum.reduce({[], %{ax: 0, ay: 0, bx: 0, by: 0, px: 0, py: 0}}, fn line,
                                                                           {machines, current} ->
        case Regex.run(~r/Button ([AB]): X\+(\d+), Y\+(\d+)/, line) do
          [_, "A", ax, ay] ->
            {machines, %{current | ax: String.to_integer(ax), ay: String.to_integer(ay)}}

          [_, "B", bx, by] ->
            {machines, %{current | bx: String.to_integer(bx), by: String.to_integer(by)}}

          _ ->
            case Regex.run(~r/Prize: X=(\d+), Y=(\d+)/, line) do
              [_, px, py] ->
                machine = %Machine{current | px: String.to_integer(px), py: String.to_integer(py)}
                {machines ++ [machine], %{ax: 0, ay: 0, bx: 0, by: 0, px: 0, py: 0}}

              _ ->
                {machines, current}
            end
        end
      end)

    machines
  end

  def run_day_13() do
    case File.read("input.txt") do
      {:ok, input} ->
        machines = parse_input(input)

        {total_prizes, total_cost} =
          Enum.reduce(machines, {0, 0}, fn machine, {prizes, cost} ->
            case solve_machine(machine) do
              -1 ->
                IO.puts("Machine #{prizes + 1}: Prize cannot be won")
                {prizes, cost}

              cost_value ->
                IO.puts("Machine #{prizes + 1}: Prize won with cost #{cost_value}")
                {prizes + 1, cost + cost_value}
            end
          end)

        IO.puts("Total prizes won: #{total_prizes}")
        IO.puts("Total cost: #{total_cost}")

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end
end
