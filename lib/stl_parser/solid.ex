defmodule StlParser.Solid do
  @moduledoc false

  defstruct [:name, :facets]

  def new(name), do: %__MODULE__{name: name, facets: []}
end
