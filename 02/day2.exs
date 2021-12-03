#! /usr/bin/env elixir

defmodule Day2 do
  @moduledoc """
  Advent of Code day 2
  """

  def main(argv) do
    {:ok, filename} = parse_argv(argv)
    {:ok, handle} = File.open(filename, [:read])
    commands = read_steering_commands(handle)
    {position, depth} = calculate_position(commands)
    {position2, depth2} = calculate_aim_position(commands)
    IO.puts("Star 1: the location of the sub is is #{position * depth}")
    IO.puts("Star 2: the location of the sub is is #{position2 * depth2}")
  end

  def parse_argv([]), do: {:error, "No filename given!"}
  def parse_argv([filename]), do: {:ok, filename}

  def read_steering_commands(handle, commands \\ []) do
    case IO.read(handle, :line) do
      {:error, reason} ->
        IO.puts("Error reading: " <> reason)

      :eof ->
        Enum.reverse(commands)

      line ->
        [direction, distance] = String.split(line)
        {distance, _rest} = Integer.parse(distance)

        case direction do
          "forward" -> read_steering_commands(handle, [{distance, 0} | commands])
          # "back -> read_steering_commands(handle, [{-distance, 0} | commands])
          "down" -> read_steering_commands(handle, [{0, distance} | commands])
          "up" -> read_steering_commands(handle, [{0, -distance} | commands])
        end
    end
  end

  def calculate_position(steering_commands, position \\ 0, depth \\ 0)

  def calculate_position([command | tail], position, depth) do
    {delta_pos, delta_depth} = command
    calculate_position(tail, position + delta_pos, depth + delta_depth)
  end

  def calculate_position(_, position, depth) do
    {position, depth}
  end

  def calculate_aim_position(steering_commands, position \\ 0, depth \\ 0, aim \\ 0)

  def calculate_aim_position([command | tail], position, depth, aim) do
    {delta_pos, delta_aim} = command

    calculate_aim_position(
      tail,
      position + delta_pos,
      depth + aim * delta_pos,
      aim + delta_aim
    )
  end

  def calculate_aim_position(_, position, depth, _aim), do: {position, depth}
end

Day2.main(System.argv())
