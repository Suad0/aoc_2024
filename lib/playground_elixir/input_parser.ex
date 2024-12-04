defmodule PlaygroundElixir.InputParser do
  def read_file(path) do
    case File.read(path) do
      {:ok, content} -> content
      {:error, reason} -> raise "Error reading file: #{reason}"
    end
  end

  def parse_day_one_data(content) do
    lines = String.split(content, "\n")

    Enum.map(lines, fn line ->
      [left, right] = String.split(line)
      {String.to_integer(left), String.to_integer(right)}
    end)
  end
end
