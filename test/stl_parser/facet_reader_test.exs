defmodule StlParser.FacetReaderTest do
  @moduledoc false
  use ExUnit.Case

  alias StlParser.{Facet, FacetReader, Helper.FileHelper, Solid}

  describe "when duplicate triangle is detected" do
    setup do
      # %{solid | facets: solid.facets ++ [facet]}
      {:ok, solid: Solid.new("testSolid")}
    end

    test "errors when duplicate detected", %{solid: solid} do
      file_path = FileHelper.duplicate_sample()

      with {:ok, file} <- File.open(file_path, [:utf8, :read]) do
        try do
          :ok = FacetReader.check_line(file, "solid duplicate")

          {:ok, %Facet{} = f1} = FacetReader.read(file, solid)
          solid = %{solid | facets: solid.facets ++ [f1]}

          assert {:error, :duplicate_facet_encountered} = FacetReader.read(file, solid)
        after
          File.close(file)
        end
      end
    end

    test "does not error otherwise", %{solid: solid} do
      file_path = FileHelper.simple_part_sample()

      with {:ok, file} <- File.open(file_path, [:utf8, :read]) do
        try do
          :ok = FacetReader.check_line(file, "solid simplePart")

          {:ok, %Facet{} = f1} = FacetReader.read(file, solid)
          solid = %{solid | facets: solid.facets ++ [f1]}

          assert {:ok, %Facet{} = f2} = FacetReader.read(file, solid)
        after
          File.close(file)
        end
      end
    end
  end

  describe "check_line" do
    test "when match" do
      file_path = FileHelper.simple_part_sample()

      with {:ok, file} <- File.open(file_path, [:utf8, :read]) do
        try do
          :ok = FacetReader.check_line(file, "solid simplePart")
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
            FacetReader.check_line(file, "not a match")

          assert actual == "solid simplePart\n"
          assert expected == "not a match"
        after
          File.close(file)
        end
      end
    end
  end
end
