defmodule PlaygroundElixir do
  @compile {:warning_level, 0}
  use Application

  alias PlaygroundElixir.{
    DayTwentyFour,
    InputParser
  }

  def start(_type, _args) do
    PlaygroundElixir.main()

    Supervisor.start_link([], strategy: :one_for_one)
  end

  def main() do
    run_day_24()
  end

  defp run_day_24() do
    IO.puts(DayTwentyFour.simulate_circuit())
  end
end
