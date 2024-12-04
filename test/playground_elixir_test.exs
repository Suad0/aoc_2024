defmodule PlaygroundElixirTest do
  use ExUnit.Case
  doctest PlaygroundElixir

  test "greets the world" do
    assert PlaygroundElixir.hello() == :world
  end
end
