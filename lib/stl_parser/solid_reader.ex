defmodule StlParser.SolidReader do
  @moduledoc false

  alias StlParser.{Facet, FacetReader, Math.Point, Solid}

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
    case FacetReader.read(file, solid) do
      {:ok, :end_solid} ->
        {:ok, solid}

      {:ok, %Facet{} = facet} ->
        read_facets({:ok, %{solid | facets: solid.facets ++ [facet]}, file})

      {:error, :duplicate_facet_encountered} ->
        {:error, :duplicate_facet_encountered}
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
