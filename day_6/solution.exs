Code.require_file("utils.exs", Path.join(__DIR__, ".."))

defmodule Day06 do
  def part1(lines) do
    parsed_rows = lines |> Enum.map(&parse_row/1)

    parsed_rows
    |> transpose()
    |> Enum.map(&solve_problem/1)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp parse_row(line) do
    Regex.scan(~r/\d+|[+*]/, line, return: :index)
    |> Enum.map(fn [{pos, len}] -> String.slice(line, pos, len)
    end)
  end

  defp transpose(rows) do
    rows
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  defp solve_problem(tokens) do
    {numbers_str, [operator]} = Enum.split(tokens, -1)
    numbers = Enum.map(numbers_str, &String.to_integer/1)

    case operator do
      "*" -> Enum.reduce(numbers, 1, &Kernel.*/2)
      "+" -> Enum.sum(numbers)
    end
  end

  def part2(lines) do
    grid = lines |> Enum.map(&String.graphemes/1)

    max_length = grid |> Enum.map(&length/1) |> Enum.max(fn -> 0 end)

    padded_grid = grid
    |> Enum.map(fn row ->
      row ++ List.duplicate(" ", max_length - length(row))
    end)

    columns = padded_grid |> transpose() |> Enum.reverse()

    columns
    |> Enum.chunk_by(&is_empty_column/1)
    |> Enum.reject(fn cols ->
      case cols do
        [col | _] -> is_empty_column(col)
        _ -> true
      end
    end)
    |> Enum.map(&solve_problem_part2/1)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp is_empty_column(col) do
    Enum.all?(col, fn char -> char == " " or char == "\r" or char == "\n" end)
  end

  defp solve_problem_part2(columns) do
    operator = columns
    |> Enum.flat_map(& &1)
    |> Enum.find(fn char -> char == "*" or char == "+" end)

    numbers = columns
    |> Enum.map(fn col ->
      col
      |> Enum.reject(fn char ->
        char == " " or char == "\r" or char == "\n" or char == "*" or char == "+"
      end)
      |> Enum.join()
    end)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.to_integer/1)

    case operator do
      "*" -> Enum.reduce(numbers, 1, &Kernel.*/2)
      "+" -> Enum.sum(numbers)
    end
  end
end

Day06.part1(Utils.get_lines_from_file("input.txt"))
Day06.part2(Utils.get_lines_no_trim("input.txt"))
