defmodule StlParser.Helper.FileHelper do
  @moduledoc false

  @empty_sample "priv/samples/empty.stl"
  def empty_sample, do: @empty_sample

  @simple_part_sample "priv/samples/simplePart.stl"
  def simple_part_sample, do: @simple_part_sample

  @moon_sample "priv/samples/moon.stl"
  def moon_sample, do: @moon_sample

  @duplicate_sample "priv/samples/duplicate.stl"
  def duplicate_sample, do: @duplicate_sample
end
