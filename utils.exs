defmodule Utils do
  def get_lines_from_file(filename) do
    File.stream!(filename)
    |> Enum.map(&String.trim/1)
  end

  def read_all_lines(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
  end

  def get_lines_no_trim(filename) do
    File.read!(filename)
    |> String.split("\n", trim: false)
    |> Enum.reject(&(&1 == ""))
  end
end
