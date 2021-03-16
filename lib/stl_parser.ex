defmodule StlParser do
  @moduledoc """
  Documentation for `StlParser`.
  """

  alias StlParser.{Math.Triangle, SolidReader}

  @doc """
  Parses ascii stl definition.

  ## Examples

      iex> StlParser.parse(nil)
      {:error, :contents_not_found}

      iex> file_path = StlParser.FileHelper.simple_part_sample()
      iex> {:ok, %{number_of_triangles: number_of_triangles, surface_area: surface_area, solid: solid}} = StlParser.parse(file_path)
      iex> assert number_of_triangles == 2
      iex> assert surface_area == 1.4142135623730956
      iex> assert solid
  """
  def parse(nil), do: {:error, :contents_not_found}

  def parse(file_path) do
    {:ok, %{facets: facets} = solid} = SolidReader.read(file_path)

    number_of_triangles = Enum.count(facets)
    surface_area = Enum.reduce(facets, 0, fn x, acc -> acc + Triangle.area(x) end)

    {:ok, %{number_of_triangles: number_of_triangles, surface_area: surface_area, solid: solid}}
  end
end
