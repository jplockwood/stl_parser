defmodule StlParser.Math.Triangle do
  @moduledoc false
  alias StlParser.Math.Point

  @doc """
  This function implements Heron's law to calculate the area of a triangle
  """
  def heron(a, b, c) do
    s = (a + b + c) / 2
    :math.sqrt(s * (s - a) * (s - b) * (s - c))
  end

  @doc """
  Calculates triangle area using 3 3D vertices
  """
  def area(%{vert1: %Point{} = vert1, vert2: %Point{} = vert2, vert3: %Point{} = vert3}) do
    a = Point.distance(vert1, vert2)
    b = Point.distance(vert2, vert3)
    c = Point.distance(vert3, vert1)
    heron(a, b, c)
  end
end
