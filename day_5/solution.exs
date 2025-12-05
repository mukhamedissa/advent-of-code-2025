Code.require_file("utils.exs", Path.join(__DIR__, ".."))

defmodule Day05 do
  def part1(lines) do
    {ranges, ids} = parse_input(lines)

    ids
    |> Enum.count(fn id -> is_fresh?(id, ranges) end)
    |> IO.inspect()
  end

  defp parse_input(lines) do
    {range_lines, id_lines} = lines |> Enum.split_while(fn line -> String.trim(line) != "" end)

    ranges =
      range_lines
      |> Enum.map(fn line ->
        [start_str, end_str] = String.split(String.trim(line), "-")
        {String.to_integer(start_str), String.to_integer(end_str)}
      end)

    ids =
      id_lines
      |> Enum.drop(1)
      |> Enum.map(fn line ->  line |> String.trim() |> String.to_integer() end)

    {ranges, ids}
  end

  defp is_fresh?(id, ranges) do
    Enum.any?(ranges, fn {range_start, range_end} -> id >= range_start and id <= range_end end)
  end

  def part2(lines) do
    {ranges, _ids} = parse_input(lines)

    ranges
    |> merge_ranges()
    |> Enum.map(fn {start, end_val} -> end_val - start + 1 end)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp merge_ranges(ranges) do
    ranges
    |> Enum.sort_by(fn {start, _} -> start end)
    |> Enum.reduce([], fn {start, end_val}, acc ->
      case acc do
        [] ->
          [{start, end_val}]

        [{prev_start, prev_end} | rest] ->
          if start <= prev_end + 1 do
            [{prev_start, max(prev_end, end_val)} | rest]
          else
            [{start, end_val} | acc]
          end
      end
    end)
    |> Enum.reverse()
  end
end

Day05.part1(Utils.get_lines_from_file("input.txt"))
Day05.part2(Utils.get_lines_from_file("input.txt"))
