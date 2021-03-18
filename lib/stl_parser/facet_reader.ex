defmodule StlParser.FacetReader do
  @moduledoc false

  alias StlParser.{Facet, Math.Point}

  def read(file) do
    facet = IO.read(file, :line)

    if String.match?(facet, ~r/.*endsolid.*/) do
      {:ok, :end_solid}
    else
      {:ok, normal} = read_facet_normal(facet)

      :ok = check_line(file, "outer loop")
      {:ok, v1} = read_vertex(file)
      {:ok, v2} = read_vertex(file)
      {:ok, v3} = read_vertex(file)
      :ok = check_line(file, "endloop")
      :ok = check_line(file, "endfacet")

      {:ok, Facet.new(normal, v1, v2, v3)}
    end
  end

  def check_line(file, partial_match) do
    line = IO.read(file, :line)

    if line =~ partial_match do
      :ok
    else
      {:error, :failed_partial_match, [line, partial_match]}
    end
  end

  defp read_vertex(file),
    do:
      ~r/.*vertex (?<x>[+-]?([0-9]*[.])?[0-9]+) (?<y>[+-]?([0-9]*[.])?[0-9]+) (?<z>[+-]?([0-9]*[.])?[0-9]+)\n/
      |> Regex.named_captures(IO.read(file, :line))
      |> Point.create_point()

  defp read_facet_normal(facet_line),
    do:
      ~r/facet normal (?<x>[+-]?([0-9]*[.])?[0-9]+) (?<y>[+-]?([0-9]*[.])?[0-9]+) (?<z>[+-]?([0-9]*[.])?[0-9]+)\n/
      |> Regex.named_captures(facet_line)
      |> Point.create_point()
end
