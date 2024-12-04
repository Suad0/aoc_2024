defmodule PlaygroundElixir.DayOne do
  def calculate_total_distance(left, right) do
    sorted_left = Enum.sort(left)
    sorted_right = Enum.sort(right)

    distances =
      Enum.zip(sorted_left, sorted_right)
      |> Enum.map(fn {l, r} -> abs(l - r) end)

    Enum.sum(distances)
  end

  def calculate_similarity(left, right) do
    Enum.reduce(left, 0, fn number, acc ->
      count_in_right = Enum.count(right, fn x -> x == number end)
      acc + number * count_in_right
    end)
  end
end
