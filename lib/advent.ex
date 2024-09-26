defmodule Advent do
  def run(year, day) do
    day = day |> to_string() |> String.pad_leading(2, "0")

    module = String.to_existing_atom("Elixir.Advent.Year#{year}.Day#{day}")
    function_name = :run

    apply(module, function_name, [])
  end
end
