Code.require_file("utils.exs", Path.join(__DIR__, ".."))

defmodule Day04 do
  def part1(lines) do
    grid = parse_grid(lines)

    grid
    |> Map.keys()
    |> Enum.filter(fn pos -> is_paper_roll?(grid, pos) and accessible?(grid, pos) end)
    |> Enum.count()
    |> IO.inspect()
  end

  defp parse_grid(lines) do
    lines
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, row}, acc ->
      line
      |> String.trim()
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {char, col}, grid -> Map.put(grid, {row, col}, char) end)
    end)
  end

  defp is_paper_roll?(grid, pos) do
    Map.get(grid, pos) == "@"
  end

  defp accessible?(grid, {row, col}) do
    neighbors = [
      {row - 1, col - 1}, {row - 1, col}, {row - 1, col + 1},
      {row, col - 1}, {row, col + 1},
      {row + 1, col - 1}, {row + 1, col}, {row + 1, col + 1}
    ]
    (neighbors |> Enum.count(fn pos -> is_paper_roll?(grid, pos) end)) < 4
  end

  def part2(lines) do
    grid = parse_grid(lines)
    remove_all_accessible(grid, 0) |> IO.inspect()
  end

  defp remove_all_accessible(grid, total_removed) do
    accessible_rolls =
      grid
      |> Map.keys()
      |> Enum.filter(fn pos -> is_paper_roll?(grid, pos) and accessible?(grid, pos) end)

    case accessible_rolls do
      [] ->
        total_removed

      rolls ->
        new_grid = Enum.reduce(rolls, grid, fn pos, acc -> Map.put(acc, pos, ".") end)
        remove_all_accessible(new_grid, total_removed + length(rolls))
    end
  end
end

Day04.part1(Utils.get_lines_from_file("input.txt"))
Day04.part2(Utils.get_lines_from_file("input.txt"))
