Code.require_file("utils.exs", Path.join(__DIR__, ".."))

defmodule Day02 do
  def part1(input) do
    input
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.flat_map(fn range_str ->
      find_invalid_ids_in_range(range_str, &is_repeated_twice?/1)
    end)
    |> Enum.sum()
    |> IO.inspect()
  end

  def part2(input) do
    input
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.flat_map(fn range_str ->
      find_invalid_ids_in_range(range_str, &is_repeated_at_least_twice?/1)
    end)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp find_invalid_ids_in_range(range_str, predicate) do
    [start_str, end_str] = String.split(range_str, "-")
    start_num = String.to_integer(start_str)
    end_num = String.to_integer(end_str)

    start_num..end_num
    |> Enum.filter(predicate)
  end

  defp is_repeated_twice?(num) do
    str = Integer.to_string(num)
    len = String.length(str)

    if rem(len, 2) == 0 do
      half = div(len, 2)
      a = String.slice(str, 0, half)
      b = String.slice(str, half, half)

      a == b and not (half > 1 and String.starts_with?(a, "0"))
    else
      false
    end
  end

  defp is_repeated_at_least_twice?(num) do
    str = Integer.to_string(num)
    len = String.length(str)

    if len < 2 do
      false
    else
      Enum.any?(1..div(len, 2), fn chunk_size ->
        if rem(len, chunk_size) != 0 do
          false
        else
          repeats = div(len, chunk_size)
          if repeats < 2 do
            false
          else
            chunk = String.slice(str, 0, chunk_size)
            if chunk_size > 1 and String.starts_with?(chunk, "0") do
              false
            else
              String.duplicate(chunk, repeats) == str
            end
          end
        end
      end)
    end
  end
end

Day02.part1(Utils.get_lines_from_file("input.txt") |> Enum.join())
Day02.part2(Utils.get_lines_from_file("input.txt") |> Enum.join())
