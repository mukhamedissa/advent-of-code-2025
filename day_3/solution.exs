Code.require_file("utils.exs", Path.join(__DIR__, ".."))

defmodule Day03 do
  def part1(lines) do
    lines
    |> Enum.map(&find_max_joltage_part1/1)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp find_max_joltage_part1(bank) do
    digits = String.graphemes(String.trim(bank))
    len = length(digits)
    max_joltage =
      for i <- 0..(len - 2),
          j <- (i + 1)..(len - 1) do
        first_digit = Enum.at(digits, i)
        second_digit = Enum.at(digits, j)
        String.to_integer(first_digit <> second_digit)
      end
      |> Enum.max()

    max_joltage
  end

  def part2(lines) do
    lines
    |> Enum.map(&find_max_joltage_part2/1)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp find_max_joltage_part2(bank) do
    digits = String.graphemes(String.trim(bank))
    len = length(digits)
    batteries_to_pick = 12

    result = pick_largest_subsequence(digits, len, batteries_to_pick)

    String.to_integer(Enum.join(result))
  end

  defp pick_largest_subsequence(digits, total_len, k) do
    pick_largest_subsequence(digits, total_len, k, 0, [])
  end

  defp pick_largest_subsequence(_digits, _total_len, 0, _start_pos, acc) do
    Enum.reverse(acc)
  end

  defp pick_largest_subsequence(digits, total_len, remaining_to_pick, start_pos, acc) do
    search_end = total_len - remaining_to_pick

    {max_digit, max_pos} =
      start_pos..search_end
      |> Enum.map(fn pos -> {Enum.at(digits, pos), pos}
      end)
      |> Enum.max_by(fn {digit, _pos} -> digit end)

    pick_largest_subsequence(
      digits,
      total_len,
      remaining_to_pick - 1,
      max_pos + 1,
      [max_digit | acc]
    )
  end
end

Day03.part1(Utils.get_lines_from_file("input.txt"))
Day03.part2(Utils.get_lines_from_file("input.txt"))
