defmodule Aoc2019 do
  def results do
    days = [
      Aoc2019.Day1,
      Aoc2019.Day2,
      Aoc2019.Day3
    ]

    Enum.each(days, fn day -> day.result() end)
  end
end
