defmodule StlParser.Math.Point do
  @moduledoc false
  alias __MODULE__

  defstruct [:x, :y, :z]

  def new(x, y, z), do: %__MODULE__{x: x, y: y, z: z}

  @doc """
  Calculates distance between two 3D points

  ## Examples
    iex> pt1 = Point.new(0, 0, 0)
    iex> pt2 = Point.new(0, 2, 0)
    iex> assert Point.distance(pt1, pt2) == 2
  """
  def distance(%Point{x: x1, y: y1, z: z1}, %Point{x: x2, y: y2, z: z2}),
    do: :math.sqrt(:math.pow(x1 - x2, 2) + :math.pow(y1 - y2, 2) + :math.pow(z1 - z2, 2))
end
