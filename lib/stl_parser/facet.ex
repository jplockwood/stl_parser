defmodule StlParser.Facet do
  @moduledoc false
  alias StlParser.Math.Point

  defstruct [:normal, :vert1, :vert2, :vert3]

  def new(%Point{} = normal, %Point{} = vert1, %Point{} = vert2, %Point{} = vert3),
    do: %__MODULE__{normal: normal, vert1: vert1, vert2: vert2, vert3: vert3}

  def same?(%__MODULE__{} = f1, %__MODULE__{} = f2) do
    f1_list = [f1.vert1, f1.vert2, f1.vert3]
    f2_list = [f2.vert1, f2.vert2, f2.vert3]

    if Enum.count(f1_list) == Enum.count(f2_list) && Enum.reduce(f1_list, true, fn x, acc ->
      acc && (x in f2_list)
    end) do
      {:ok, true}
    else
      {:ok, false}
    end
  end
end
