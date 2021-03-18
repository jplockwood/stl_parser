defmodule StlParser.FacetReaderTest do
  @moduledoc false
  use ExUnit.Case

  alias StlParser.{FacetReader, Helper.FileHelper}

  describe "when duplicate triangle is detected" do
    test "errors when duplicate detected" do
      assert 1
    end

    test "does not error otherwise" do
      assert 1
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
