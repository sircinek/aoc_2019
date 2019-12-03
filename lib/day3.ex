defmodule Aoc2019.Day3 do
    @moduledoc """
    Day 3 of Advent of Code 2019.
    """
  
    @doc """
    First problem.
  
    ## Examples
     
    """
  
    def a(input \\ input()) do
      input
      |> cable_grids()
      |> find_intersections()
      |> closest_intersection()
    end
  
    @doc ~S"""
    Second problem.
  
    ## Examples
    iex> Aoc2019.Day3.b(Aoc2019.Day3.parse("R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83"))
    610

    iex> Aoc2019.Day3.b(Aoc2019.Day3.parse("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7"))
    410

    iex> Aoc2019.Day3.b(Aoc2019.Day3.parse("R8,U5,L5,D3\nU7,R6,D4,L4"))
    30
    """

    
    def b(input \\ input()) do
      [wire1, wire2] = input
      g_w1 = grid_list(wire1) |> Enum.reverse()
      g_w2 = grid_list(wire2) |> Enum.reverse()
      intersections = input |> cable_grids() |> find_intersections() |> (&(MapSet.delete(&1, {0,0}))).()
      Enum.reduce(intersections, 99999999999999, 
        fn {x, y}, dist -> 
          filter = fn {^x, ^y, _} -> true; {_, _,_} -> false end
          {_, _, w1} = Enum.find(g_w1, filter)
          {_, _, w2} = Enum.find(g_w2, filter)
          intersection_steps = w1 + w2
          if intersection_steps < dist do
            intersection_steps
          else
            dist
          end
        end)
    end
  
    def result do
      IO.puts("Day3:")
      IO.puts("Part1: #{a()}")
      IO.puts("Part2: #{b()}")
    end

    def input do
      "inputs/day3.txt"
      |> Parser.read_file() 
      |> parse()
    end

    def cable_grids(input) do
      Enum.map(input, &grid/1)
    end

    defp grid(wire_instructions)  do
      insert_points = &MapSet.put(&2, &1)
      move = 
        fn 
          {:up, distance}, {{x, y}, points} -> 
            new_y = y + distance
            line = for ys <- y..new_y, do: {x, ys}
            {{x, new_y}, Enum.reduce(line, points, insert_points)}
          {:down, distance}, {{x, y}, points} -> 
            new_y = y - distance
            line = for ys <- y..new_y, do: {x, ys}
            {{x, new_y}, Enum.reduce(line, points, insert_points)}
          {:left, distance}, {{x,y}, points} ->
            new_x = x - distance
            line = for xs <- x..new_x, do: {xs, y}
            {{new_x, y}, Enum.reduce(line, points, insert_points)}
          {:right, distance}, {{x,y}, points} -> 
            new_x = x + distance
            line = for xs <- x..new_x, do: {xs, y}
            {{new_x, y}, Enum.reduce(line, points, insert_points)}
        end

      {_, grid} = Enum.reduce(wire_instructions, {{0,0}, MapSet.new()}, move)
      grid
    end

    defp grid_list(wire_instructions)  do
      insert_points = &([&1|&2])
      move = 
        fn 
          {:up, distance}, {{x, y, steps}, points} -> 
            new_y = y + distance
            {line, steps} = Enum.reduce(y..new_y, {[], steps}, fn y, {acc, step} -> {[{x, y, step} | acc], step + 1} end)
            {{x, new_y, steps - 1}, Enum.reduce(line, points, insert_points)}
          {:down, distance}, {{x, y, steps}, points} -> 
            new_y = y - distance
            {line, steps}  = Enum.reduce(y..new_y, {[], steps}, fn y, {acc, step} -> {[{x, y, step} | acc], step + 1} end)
            {{x, new_y, steps - 1}, Enum.reduce(line, points, insert_points)}
          {:left, distance}, {{x, y, steps}, points} ->
            new_x = x - distance
            {line, steps}  = Enum.reduce(x..new_x, {[], steps}, fn x, {acc, step} -> {[{x, y, step} | acc], step + 1} end)
            {{new_x, y, steps - 1}, Enum.reduce(line, points, insert_points)}
          {:right, distance}, {{x, y, steps}, points} -> 
            new_x = x + distance
            {line, steps}  = Enum.reduce(x..new_x, {[], steps}, fn x, {acc, step} -> {[{x, y, step} | acc], step + 1} end)
            {{new_x, y, steps - 1}, Enum.reduce(line, points, insert_points)}
        end

      {_, grid} = Enum.reduce(wire_instructions, {{0,0,0}, []}, move)
      grid
    end

    defp find_intersections([first, second]) do
      MapSet.intersection(first, second)
    end

    defp closest_intersection(intersections) do
      intersections
      |> MapSet.delete({0, 0})
      |> Enum.map(fn {x, y} -> abs(x) + abs(y) end)
      |> Enum.min()
    end

    def parse(input) do
      input
      |> String.split()
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(&list_instruction/1)
    end

    defp instruction(<<direction, distance::binary>>) do
      distance = String.to_integer(distance)
      case direction do
        ?U -> {:up, distance}
        ?L -> {:left, distance}
        ?R -> {:right, distance}
        ?D -> {:down, distance}
      end
    end

    defp list_instruction(instructions), do: Enum.map(instructions, &instruction/1)
end
  