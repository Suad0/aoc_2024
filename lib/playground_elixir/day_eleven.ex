defmodule PlaygroundElixir.DayEleven do
  defp initialize_counts(initial_stones) do
    Enum.reduce(initial_stones, %{}, fn stone, acc ->
      Map.update(acc, stone, 1, &(&1 + 1))
    end)
  end

  defp transform_counts(stone_counts) do
    Enum.reduce(stone_counts, %{}, fn {stone, count}, acc ->
      cond do
        stone == 0 ->
          Map.update(acc, 1, count, &(&1 + count))

        rem(Integer.digits(stone) |> length(), 2) == 0 ->
          digits = Integer.digits(stone)
          mid = div(length(digits), 2)
          {left, right} = Enum.split(digits, mid)
          left_num = Integer.undigits(left)
          right_num = Integer.undigits(right)

          acc
          |> Map.update(left_num, count, &(&1 + count))
          |> Map.update(right_num, count, &(&1 + count))

        true ->
          new_stone = stone * 2024
          Map.update(acc, new_stone, count, &(&1 + count))
      end
    end)
  end

  def simulate_stones(initial_stones, blinks) do
    initial_counts = initialize_counts(initial_stones)

    final_counts =
      Enum.reduce(1..blinks, initial_counts, fn _, acc ->
        transform_counts(acc)
      end)

    Enum.reduce(final_counts, 0, fn {_stone, count}, acc -> acc + count end)
  end
end
