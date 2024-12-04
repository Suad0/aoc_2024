defmodule PlaygroundElixir do
  @compile {:warning_level, 0}
  use Application

  alias PlaygroundElixir.{DayOne, DayTwo, DayThree, DayFour, InputParser}

  def start(_type, _args) do
    PlaygroundElixir.main()

    Supervisor.start_link([], strategy: :one_for_one)
  end

  def main() do
    run_day_four()
  end

  defp run_day_one do
    path = "/Users/suad/ProjektePrivate/playground_elixir/day_one_data.txt"
    content = InputParser.read_file(path)
    {left_list, right_list} = InputParser.parse_day_one_data(content)

    total_distance = DayOne.calculate_total_distance(left_list, right_list)
    similarity_score = DayOne.calculate_similarity(left_list, right_list)

    IO.puts("Day 1: Total distance = #{total_distance}")
    IO.puts("Day 1: Similarity score = #{similarity_score}")
  end

  defp run_day_two() do
    path = "priv/input_files/day_two_input.txt"
    content = InputParser.read_file(path)

    safe_count = DayTwo.count_safe_reports_with_dampener(content)
    IO.puts("Day 2: Safe paths with dampener = #{safe_count}")
  end

  defp run_day_three() do
    path = "priv/input_files/day_three_input.txt"
    content = InputParser.read_file(path)

    total = DayThree.extract_and_sum_mul_with_conditions(content)
    IO.puts("Day 3: Total sum of valid mul operations = #{total}")
  end

  defp run_day_four() do
    DayFour.run()
  end
end
