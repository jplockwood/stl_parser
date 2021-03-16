defmodule StlParser do
  @moduledoc """
  Documentation for `StlParser`.
  """

  alias StlParser.{Math.Triangle, SolidReader}
  require Logger

  @doc """
  Parses ascii stl definition.

  ## Examples

      iex> StlParser.parse(nil)
      {:error, :contents_not_found}

      iex> file_path = StlParser.Helper.FileHelper.simple_part_sample()
      iex> {:ok, %{number_of_triangles: number_of_triangles, surface_area: surface_area, name: "simplePart"}} = StlParser.parse(file_path)
      iex> assert number_of_triangles == 2
      iex> assert surface_area == 1.4142135623730956
  """
  def parse(nil), do: {:error, :contents_not_found}

  def parse(file_path) do
    Logger.debug(fn -> "Parsing from path: #{file_path}" end)
    {:ok, %{name: name, facets: facets}} = SolidReader.read(file_path)
    Logger.debug(fn -> "Finished parsing #{name} from path: #{file_path}" end)

    number_of_triangles = Enum.count(facets)
    surface_area = Enum.reduce(facets, 0, fn x, acc -> acc + Triangle.area(x) end)

    {:ok, %{number_of_triangles: number_of_triangles, surface_area: surface_area, name: name}}
  end
end
