defmodule PlaygroundElixir.DaySeven do
  def is_valid(target, ns, p2) do
    do_is_valid(target, ns, p2)
  end

  defp do_is_valid(target, ns, p2) do
    cond do
      length(ns) == 1 ->
        hd(ns) == target

      length(ns) < 2 ->
        false

      true ->
        addition =
          do_is_valid(target, [Enum.at(ns, 0) + Enum.at(ns, 1)] ++ Enum.slice(ns, 2..-1//1), p2)

        multiplication =
          do_is_valid(target, [Enum.at(ns, 0) * Enum.at(ns, 1)] ++ Enum.slice(ns, 2..-1//1), p2)

        concatenation =
          p2 and
          do_is_valid(
            target,
            [String.to_integer("#{Enum.at(ns, 0)}#{Enum.at(ns, 1)}")] ++ Enum.slice(ns, 2..-1//1),
            p2
          )

        addition or multiplication or concatenation
    end
  end

  def solve do
    {:ok, input} = File.read("input.txt")

    result =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.reduce({0, 0}, fn line, {p1, p2} ->
        [target_str, ns_str] = String.split(line, ":")
        target = String.to_integer(String.trim(target_str))
        ns = String.trim(ns_str) |> String.split(~r/\s+/) |> Enum.map(&String.to_integer/1)

        p1 = if is_valid(target, ns, false), do: p1 + target, else: p1
        p2 = if is_valid(target, ns, true), do: p2 + target, else: p2

        {p1, p2}
      end)

    elem(result, 0)
  end
end
