defmodule Mix.Tasks.Advent.Gen.Day do
  use Igniter.Mix.Task

  @example "mix advent.gen.day 1 2024"

  @shortdoc "Generates scaffold for an advent of code solution"
  @moduledoc """
  #{@shortdoc}

  ## Example

  ```bash
  #{@example}
  ```

  ## Options

  * [day] The day of the month to generate. Default to the current day in EST.
  * [year] The year to generate. Default to the current year.
  """

  def info(_argv, _composing_task) do
    %Igniter.Mix.Task.Info{
      example: @example,
      positional: [{:day, optional: true}, {:year, optional: true}]
    }
  end

  def igniter(igniter, argv) do
    {arguments, _argv} = positional_args!(argv)

    day =
      Map.get(arguments, :day)
      |> advent_day()
      |> to_string()
      |> String.pad_leading(2, "0")

    year =
      Map.get(arguments, :year)
      |> advent_year()
      |> to_string()

    module_name = Igniter.Code.Module.parse("Advent.Year#{year}.Day#{day}")
    test_module_name = "#{module_name}Test"

    igniter
    |> Igniter.Code.Module.create_module(module_name, """
    def run do
    end
    """)
    |> Igniter.Code.Module.create_module(
      test_module_name,
      """
      use ExUnit.Case
      import #{module_name}

      @tag :skip
      test "run" do
        ans = 0
        result = run()

        assert ans == result
      end
      """,
      path: Igniter.Code.Module.proper_test_location(test_module_name)
    )
  end

  defp advent_day(nil) do
    {:ok, now} = DateTime.now("America/New_York")
    now.day
  end

  defp advent_day(day) when is_binary(day) do
    case Integer.parse(day) do
      {day, _} when day in 1..25 -> day
      _ -> raise ArgumentError, "invalid day (must be int between 1 and 25)"
    end
  end

  defp advent_year(nil) do
    {:ok, now} = DateTime.now("America/New_York")
    now.year
  end

  defp advent_year(year) do
    case Integer.parse(year) do
      {year, _} when year > 0 -> year
      _ -> raise ArgumentError, "invalid year (must be int)"
    end
  end
end
