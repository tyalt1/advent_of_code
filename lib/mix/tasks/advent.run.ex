defmodule Mix.Tasks.Advent.Run do
  use Mix.Task

  @moduledoc """

  Run a Advent of code solution.

  ## Example

  ```bash
  mix advent.run          # current day
  mix advent.run  1       # specific day
  mix advent.run  1 2023  # specific day and year
  ```

  ## Options

  * [day] The day of the month to run. Default to the current day in EST.
  * [year] The year to run. Default to the current year.
  """

  def run(args) do
    {:ok, now} = DateTime.now("America/New_York")

    {day, year} =
      case args do
        [] ->
          {now.day, now.year}

        [day_str] ->
          {day, _} = Integer.parse(day_str)
          {day, now.year}

        [day_str, year_str | _] ->
          {day, _} = Integer.parse(day_str)
          {year, _} = Integer.parse(year_str)
          {day, year}
      end

    Advent.run(day, year)
  end
end
