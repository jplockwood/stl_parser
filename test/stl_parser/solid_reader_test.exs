defmodule StlParser.SolidReaderTest do
  use ExUnit.Case

  alias StlParser.{Helper.FileHelper, SolidReader}

  @moduletag :capture_log

  test "returns solid map" do
    {:ok,
     %{
       name: name,
       facets: facets
     }} =
      FileHelper.simple_part_sample()
      |> SolidReader.read()

    assert name == "simplePart"
    assert Enum.count(facets) == 2
  end

  test "larger file" do
    {:ok,
     %{
       name: name,
       facets: facets
     }} =
      FileHelper.moon_sample()
      |> SolidReader.read()

    assert name == "Moon"
    assert Enum.count(facets) == 116
  end

  describe "what to do with empty stl files" do
    test "should return new solid with no facets" do
      {:ok,
       %{
         name: name,
         facets: facets
       }} =
        FileHelper.empty_sample()
        |> SolidReader.read()

      assert name == "empty"
      assert Enum.empty?(facets)
    end
  end
end
