defmodule PlaygroundElixir.DayTwentyFour do
  import Bitwise

  def simulate_circuit do
    {:ok, input} = File.read("input.txt")

    {initial_values, gates} = parse_input(input)

    wire_values = resolve_gates(initial_values, gates)

    # Find and convert z wires to binary
    z_wires =
      wire_values
      |> Enum.filter(fn {wire, _} -> String.starts_with?(wire, "z") end)
      |> Enum.sort_by(fn {wire, _} -> String.slice(wire, 1..-1) |> String.to_integer() end)
      |> Enum.map(fn {_, value} -> value end)
      |> Enum.reverse()
      |> Enum.join()
      |> Integer.parse(2)
      |> elem(0)

    z_wires
  end

  defp parse_input(input) do
    lines = String.split(input, "\n", trim: true)

    initial_values =
      lines
      |> Enum.filter(&String.contains?(&1, ":"))
      |> Enum.map(fn line ->
        [wire, value] = String.split(line, ":", trim: true)
        {String.trim(wire), String.trim(value) |> String.to_integer()}
      end)
      |> Enum.into(%{})

    gates =
      lines
      |> Enum.filter(&String.contains?(&1, "->"))
      |> Enum.map(&String.trim/1)

    {initial_values, gates}
  end

  defp resolve_gates(initial_values, gates) do
    wire_values = initial_values

    resolve_gates_recursive(wire_values, gates)
  end

  defp resolve_gates_recursive(wire_values, []), do: wire_values

  defp resolve_gates_recursive(wire_values, gates) do
    {resolved, unresolved} =
      Enum.split_with(gates, fn gate ->
        resolve_gate(wire_values, gate)
      end)

    if Enum.empty?(resolved) do
      raise "Could not resolve remaining gates: #{inspect(unresolved)}"
    end

    new_wire_values =
      Enum.reduce(resolved, wire_values, fn gate, acc ->
        resolve_gate_and_update(acc, gate)
      end)

    resolve_gates_recursive(new_wire_values, unresolved)
  end

  defp resolve_gate(wire_values, gate) do
    [expression, output] = String.split(gate, "->", trim: true)
    output = String.trim(output)
    parts = String.split(expression)

    case parts do
      [input1, op, input2] ->
        val1 = get_wire_value(wire_values, input1)
        val2 = get_wire_value(wire_values, input2)
        val1 != nil and val2 != nil

      _ ->
        false
    end
  end

  defp resolve_gate_and_update(wire_values, gate) do
    [expression, output] = String.split(gate, "->", trim: true)
    output = String.trim(output)
    parts = String.split(expression)

    result =
      case parts do
        [input1, "AND", input2] ->
          val1 = get_wire_value(wire_values, input1)
          val2 = get_wire_value(wire_values, input2)
          val1 &&& val2

        [input1, "OR", input2] ->
          val1 = get_wire_value(wire_values, input1)
          val2 = get_wire_value(wire_values, input2)
          val1 ||| val2

        [input1, "XOR", input2] ->
          val1 = get_wire_value(wire_values, input1)
          val2 = get_wire_value(wire_values, input2)
          val1 ^^^ val2
      end

    Map.put(wire_values, output, result)
  end

  defp get_wire_value(wire_values, wire) do
    case Integer.parse(wire) do
      {value, ""} -> value
      _ -> Map.get(wire_values, wire)
    end
  end

  # Run the simulation and print the result
  # result = CircuitSimulator.simulate_circuit()
  # IO.puts(result)
end
