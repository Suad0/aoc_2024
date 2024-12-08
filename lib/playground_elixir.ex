defmodule PlaygroundElixir do
  @compile {:warning_level, 0}
  use Application

  alias PlaygroundElixir.{
    DayOne,
    DayTwo,
    DayThree,
    DayFour,
    DayFive,
    DaySix,
    DaySeven,
    DayEight,
    InputParser
  }

  def start(_type, _args) do
    PlaygroundElixir.main()

    Supervisor.start_link([], strategy: :one_for_one)
  end

  def main() do
    run_day_eight()
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

  defp run_day_five() do
    input = """
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13

    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47
    """

    IO.puts(DayFive.process_incorrect_updates(input))
  end

  defp run_day_six() do
    filename = System.argv() |> List.first() || "input.txt"

    IO.puts(DaySix.solve(filename))
  end

  def run_day_seven() do
    IO.puts(DaySeven.solve())
  end

  defp run_day_eight() do
    IO.puts(DayEight.main())
  end
end
