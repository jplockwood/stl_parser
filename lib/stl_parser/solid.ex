defmodule StlParser.Solid do
  @moduledoc false
  alias __MODULE__

  defstruct [:name, :facets]

  def new(name), do: %__MODULE__{name: name, facets: []}
end
