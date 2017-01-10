defmodule Identicon do
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares

  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid =
      Enum.filter grid, fn({code, _index}) ->
      rem(code,2) == 0
    end

    %Identicon.Image{image | grid: grid}
  end

  def build_grid(%Identicon.Image{hex: hex}= image) do
  grid =
    hex
    |> Enum.chunk(3)
    # '&' sym  passes a ref to a fN, 1 is the airity
    |> Enum.map(&mirror_row/1)
    |> List.flatten
    |> Enum.with_index

    %Identicon.Image {image | grid: grid}

  end

  def mirror_row(row) do
    # [121,2,50]
    [first, second | _tail] = row
    # [121,2,50,2,121]
    row ++ [second, first]
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    # this was refactored...you can pattern match the arguments in the parens
    %Identicon.Image{image | color: {r, g, b}}
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5,input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end
end
