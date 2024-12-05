defmodule PlaygroundElixir.DayFive do
  def parse_input(input) do
    [rules_section, updates_section] = String.trim(input) |> String.split("\n\n")

    rules =
      rules_section
      |> String.split("\n")
      |> Enum.map(fn rule ->
        rule
        |> String.split("|")
        |> Enum.map(&String.to_integer/1)
      end)

    updates =
      updates_section
      |> String.split("\n")
      |> Enum.map(fn update ->
        update
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
      end)

    %{rules: rules, updates: updates}
  end

  def is_update_valid(update, rules) do
    page_order =
      update
      |> Enum.with_index()
      |> Enum.into(%{})

    Enum.all?(rules, fn [x, y] ->
      cond do
        Map.has_key?(page_order, x) and Map.has_key?(page_order, y) ->
          page_order[x] <= page_order[y]

        true ->
          true
      end
    end)
  end

  def find_middle_page(update) do
    Enum.at(update, div(length(update), 2))
  end

  def reorder_update(update, rules) do
    page_set = MapSet.new(update)

    # Build graph and in-degree map
    {graph, in_degree} =
      Enum.reduce(update, {%{}, %{}}, fn page, {graph, in_degree} ->
        graph = Map.put(graph, page, [])
        in_degree = Map.put(in_degree, page, 0)
        {graph, in_degree}
      end)

    {graph, in_degree} =
      Enum.reduce(rules, {graph, in_degree}, fn [x, y], {graph, in_degree} ->
        if MapSet.member?(page_set, x) and MapSet.member?(page_set, y) do
          graph = Map.update!(graph, x, fn neighbors -> [y | neighbors] end)
          in_degree = Map.update!(in_degree, y, fn degree -> degree + 1 end)
          {graph, in_degree}
        else
          {graph, in_degree}
        end
      end)

    do_topological_sort(graph, in_degree)
  end

  def process_incorrect_updates(input) do
    %{rules: rules, updates: updates} = parse_input(input)

    updates
    |> Enum.filter(fn update -> not is_update_valid(update, rules) end)
    |> Enum.map(fn update ->
      update
      |> reorder_update(rules)
      |> find_middle_page()
    end)
    |> Enum.sum()
  end

  defp do_topological_sort(graph, in_degree) do
    queue =
      in_degree
      |> Enum.filter(fn {_, degree} -> degree == 0 end)
      |> Enum.map(fn {node, _} -> node end)

    do_sort(graph, in_degree, queue, [])
  end

  defp do_sort(graph, in_degree, [], sorted), do: Enum.reverse(sorted)

  defp do_sort(graph, in_degree, [current | queue], sorted) do
    sorted = [current | sorted]

    {graph, in_degree, new_queue} =
      Enum.reduce(graph[current], {graph, in_degree, queue}, fn neighbor,
                                                                {graph, in_degree, new_queue} ->
        in_degree = Map.update!(in_degree, neighbor, fn degree -> degree - 1 end)

        new_queue =
          if in_degree[neighbor] == 0, do: [neighbor | new_queue], else: new_queue

        {graph, in_degree, new_queue}
      end)

    do_sort(graph, in_degree, new_queue, sorted)
  end
end
