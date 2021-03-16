defmodule StlParser.SolidReaderTest do
  use ExUnit.Case

  alias StlParser.{FileHelper, SolidReader}

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

  describe "check_line" do
    test "when match" do
      file_path = FileHelper.simple_part_sample()

      with {:ok, file} <- File.open(file_path, [:utf8, :read]) do
        try do
          :ok = SolidReader.check_line(file, "solid simplePart")
        after
          File.close(file)
        end
      end
    end

    test "when not a match" do
      file_path = FileHelper.simple_part_sample()

      with {:ok, file} <- File.open(file_path, [:utf8, :read]) do
        try do
          {:error, :failed_partial_match, [actual | [expected | _]]} =
            SolidReader.check_line(file, "not a match")

          assert actual == "solid simplePart\n"
          assert expected == "not a match"
        after
          File.close(file)
        end
      end
    end
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
