defmodule StlParserTest do
  use ExUnit.Case
  doctest StlParser
  alias StlParser.Helper.FileHelper

  test "simple part" do
    file_path = FileHelper.simple_part_sample()

    {:ok,
     %{number_of_triangles: number_of_triangles, surface_area: surface_area, name: "simplePart"}} =
      StlParser.parse(file_path)

    assert number_of_triangles == 2
    assert Float.round(surface_area, 4) == 1.4142
  end

  test "moon part" do
    file_path = FileHelper.moon_sample()

    {:ok, %{number_of_triangles: number_of_triangles, surface_area: surface_area, name: "Moon"}} =
      StlParser.parse(file_path)

    assert number_of_triangles == 116
    assert Float.round(surface_area, 4) == 7.7726
  end
end
