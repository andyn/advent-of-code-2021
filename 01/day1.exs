#! /usr/bin/env elixir

defmodule Day1 do
  @moduledoc """
  Advent of Code day 1

  Takes a list of numbers ("depth measurements") and counts the occurrences where
  the difference between two consecutive numbers is positive.
  """

  def main(argv) do
    {:ok, filename} = parse_argv(argv)
    {:ok, handle} = File.open(filename, [:read])
    numbers = read_numbers(handle)
    rising = count_rising(numbers)
    rising_windowed = window3(numbers) |> count_rising()
    IO.puts("Star 1: the number of rising depth measurements is #{rising}")
    IO.puts("Star 2: the number of rising depth measurements is #{rising_windowed}")
  end

  def parse_argv([]), do: {:error, "No filename given!"}
  def parse_argv([filename]), do: {:ok, filename}

  def read_numbers(handle, numbers \\ []) do
    case IO.read(handle, :line) do
      {:error, reason} ->
        IO.puts("Error reading: " <> reason)

      :eof ->
        Enum.reverse(numbers)

      line ->
        {number, _rest} = Integer.parse(line)
        read_numbers(handle, [number | numbers])
    end
  end

  def count_rising(measurements, count \\ 0)

  def count_rising([current | tail = [next | _]], count) do
    if current < next do
      count_rising(tail, count + 1)
    else
      count_rising(tail, count)
    end
  end

  def count_rising(_, count), do: count

  def window3(list, windowed \\ [])

  def window3([first | tail = [second | [third | _]]], windowed) do
    [first | tail] |> IO.inspect()
    window3(tail, [first + second + third | windowed])
  end

  def window3(_, windowed), do: Enum.reverse(windowed)

  def usage() do
    IO.puts("Usage: day1.exs FILE")
  end
end

Day1.main(System.argv())
