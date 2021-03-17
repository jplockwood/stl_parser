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

  defp read_facet_normal(facet_line), do:
    ~r/facet normal (?<x>[+-]?([0-9]*[.])?[0-9]+) (?<y>[+-]?([0-9]*[.])?[0-9]+) (?<z>[+-]?([0-9]*[.])?[0-9]+)\n/
    |> Regex.named_captures(facet_line)
    |> create_point()

  defp read_vertex(file), do:
    ~r/.*vertex (?<x>[+-]?([0-9]*[.])?[0-9]+) (?<y>[+-]?([0-9]*[.])?[0-9]+) (?<z>[+-]?([0-9]*[.])?[0-9]+)\n/
    |> Regex.named_captures(IO.read(file, :line))
    |> create_point()

  defp create_point(point_info),
    do:
      with(
        {x, _} <- Float.parse(point_info["x"]),
        {y, _} <- Float.parse(point_info["y"]),
        {z, _} <- Float.parse(point_info["z"]),
        do: {:ok, Point.new(x, y, z)}
      )

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
