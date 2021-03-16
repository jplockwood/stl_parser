defmodule StlParser.Facet do
  @moduledoc false
  alias StlParser.Math.Point

  defstruct [:normal, :vert1, :vert2, :vert3]

  def new(%Point{} = normal, %Point{} = vert1, %Point{} = vert2, %Point{} = vert3),
    do: %__MODULE__{normal: normal, vert1: vert1, vert2: vert2, vert3: vert3}
end
