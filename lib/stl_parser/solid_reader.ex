defmodule StlParser.SolidReader do
  @moduledoc false

  alias StlParser.{Facet, Math.Point, Solid}

  def read(nil), do: :contents_not_found

  def read(file_path) do
    with {:ok, file} <- File.open(file_path, [:utf8, :read]) do
      try do
        file
        |> init_solid()
        |> read_facets()
      after
        File.close(file)
      end
    end
  end

  defp read_facets({:ok, solid, file}) do
    case read_facet(file) do
      {:ok, :end_solid} ->
        {:ok, solid}

      {:ok, %Facet{} = facet} ->
        read_facets({:ok, %{solid | facets: solid.facets ++ [facet]}, file})
    end
  end

  defp read_facet(file) do
    facet =
      file
      |> IO.read(:line)

    if String.match?(facet, ~r/.*endsolid.*/) do
      {:ok, :end_solid}
    else
      facet_start_point =
        Regex.named_captures(
          ~r/facet normal (?<x>[+-]?([0-9]*[.])?[0-9]+) (?<y>[+-]?([0-9]*[.])?[0-9]+) (?<z>[+-]?([0-9]*[.])?[0-9]+)\n/,
          facet
        )

      {x, _} = Float.parse(facet_start_point["x"])
      {y, _} = Float.parse(facet_start_point["y"])
      {z, _} = Float.parse(facet_start_point["z"])

      :ok = check_line(file, "outer loop")
      {:ok, v1} = read_vertex(file)
      {:ok, v2} = read_vertex(file)
      {:ok, v3} = read_vertex(file)
      :ok = check_line(file, "endloop")
      :ok = check_line(file, "endfacet")

      {:ok, Point.new(x, y, z) |> Facet.new(v1, v2, v3)}
    end
  end

  defp read_vertex(file) do
    vert =
      file
      |> IO.read(:line)

    facet_start_point =
      Regex.named_captures(
        ~r/.*vertex (?<x>[+-]?([0-9]*[.])?[0-9]+) (?<y>[+-]?([0-9]*[.])?[0-9]+) (?<z>[+-]?([0-9]*[.])?[0-9]+)\n/,
        vert
      )

    {x, _} = Float.parse(facet_start_point["x"])
    {y, _} = Float.parse(facet_start_point["y"])
    {z, _} = Float.parse(facet_start_point["z"])

    {:ok, Point.new(x, y, z)}
  end

  def check_line(file, partial_match) do
    line = IO.read(file, :line)

    if line =~ partial_match do
      :ok
    else
      {:error, :failed_partial_match, [line, partial_match]}
    end
  end

  defp init_solid(file),
    do: {
      :ok,
      file
      |> IO.read(:line)
      |> (fn line ->
            ~r/solid (?<name>.*)\n/
            |> Regex.named_captures(line)
            |> Map.get("name")
          end).()
      |> Solid.new(),
      file
    }
end
