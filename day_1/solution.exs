Code.require_file("utils.exs", Path.join(__DIR__, ".."))

defmodule Day01 do
  def part1(lines) do
    {final_position, zero_hits} =
      Enum.reduce(lines, {50, 0}, fn line, {pos, hits} ->
        {direction, amount} = parse(line)

        new_position =
          case direction do
            "L" -> Integer.mod(pos - amount, 100)
            "R" -> Integer.mod(pos + amount, 100)
          end

        hits = if new_position == 0, do: hits + 1, else: hits
        {new_position, hits}
      end)

    IO.puts(final_position)
    IO.puts(zero_hits)
  end

  def part2(lines) do
    {final_position, zero_hits} =
      Enum.reduce(lines, {50, 0}, fn line, {pos, hits} ->
        {dir, amount} = parse(line)
        {new_pos, click_hits} = rotate(pos, dir, amount)
        {new_pos, hits + click_hits}
      end)

    IO.puts(final_position)
    IO.puts(zero_hits)
  end

  defp parse(line) do
    line = String.trim(line)
    {direction, amount} = String.split_at(line, 1)
    {direction, String.to_integer(amount)}
  end

  defp rotate(pos, "R", amount) do
    Enum.reduce(1..amount, {pos, 0}, fn _step, {cur, hits} ->
      next = Integer.mod(cur + 1, 100)
      hits = if next == 0, do: hits + 1, else: hits
      {next, hits}
    end)
  end

  defp rotate(pos, "L", amount) do
    Enum.reduce(1..amount, {pos, 0}, fn _step, {cur, hits} ->
      next = Integer.mod(cur - 1, 100)
      hits = if next == 0, do: hits + 1, else: hits
      {next, hits}
    end)
  end
end

Day01.part1(Utils.get_lines_from_file("input.txt"))
Day01.part2(Utils.get_lines_from_file("input.txt"))
