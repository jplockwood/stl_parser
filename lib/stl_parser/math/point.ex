defmodule StlParser.Math.Point do
  @moduledoc false
  alias __MODULE__

  defstruct [:x, :y, :z]

  def new(x, y, z), do: %__MODULE__{x: x, y: y, z: z}

  @doc """
  Calcualtes distance between two 3D points
  """
  def distance(%Point{} = pt1, %Point{} = pt2),
    do:
      :math.sqrt(
        :math.pow(pt1.x - pt2.x, 2) + :math.pow(pt1.y - pt2.y, 2) + :math.pow(pt1.z - pt2.z, 2)
      )
end
