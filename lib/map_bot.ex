defmodule MapBot do
  @moduledoc """
  `MapBot` builds Elixir Maps/Structs based on factory definitions and attributes.
  """

  @type name :: module() | atom()
  @type attributes :: map() | keyword()
  @type result :: struct() | map()

  @doc """
  Builds an Elixir Map/Struct.

  ## Examples

      iex> MapBot.build(:tomato)
      %{name: "Tomato", color: :red}

      iex> MapBot.build(:tomato, color: :green)
      %{name: "Tomato", color: :green}

      iex> MapBot.build(MapBot.Car, color: :yellow)
      %MapBot.Car{model: "SUV", color: :yellow}

      iex> MapBot.build(MapBot.Car, %{color: :yellow})
      %MapBot.Car{model: "SUV", color: :yellow}
  """
  @spec build(name, attributes) :: result
  def build(name, attrs \\ []) do
    map = factories().new(name)
    Enum.reduce(attrs, map, &apply_attr/2)
  end

  defp apply_attr({key, value}, map), do: Map.put(map, key, value)

  defp factories() do
    Application.get_env(:map_bot, :factories)
  end
end
