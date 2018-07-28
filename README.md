# MapBot

`MapBot` builds Elixir Maps/Structs based on factory definitions and attributes.

Note that this library is very flexible and also very light. It does not add any dependency in our application neither it requires third party code such `Ecto` or `Faker`. In addition to that to integrate your MapBot factories with any other library like `Ecto` or `Faker` it's also very easy as the factory definition remains if your application.

## Factories Definition:

Factories are defined in a single module in your application such as:

```elixir
defmodule YourApp.Factory do
  use MapBot

  def new(YourApp.Car), do: %YourApp.Car{model: "SUV", color: :black}
  def new(:greenish), do: %{color: :green}
  def new(:tomato), do: %{name: "Cherry Tomato", color: :red}
  def new(:with_code), do: %{code: &"CODE-#{&1}"}
end
```

This module simply defines by function definition pattern match how you map is going to be built. If we call `YourApp.Factory.build/2` the first argument is used for pattern match with your factory definition and the second is a list of attributes that will override the built map.

### Sequences:

In order to prevent not unique errors by database constraints and to have a more flexible data you can use a sequence inside your factory definition. To do that use a function with arity 1 and the first argument of that function will be a auto incremented integer.

```elixir
defmodule YourApp.Factory do
  def new(:with_code), do: %{code: &"CODE-#{&1}"}
end
```

will produce:

```elixir
YourApp.Factory.build(:with_code) # %{code: "CODE-1"}
YourApp.Factory.build(:with_code) # %{code: "CODE-2"}
YourApp.Factory.build(:with_code) # %{code: "CODE-3"}
```

Note that this `&"CODE-#{&1}"` is a very short Elixir syntax equivalent for:

```elixir
fn i -> "CODE-#{i}" end
# is the same as `&"CODE-#{&1}"`
```

### Traits:

Note that if you want to compose multiple definitions to your map you can use a `trait`. This is a great feature that allows our factory definition to be very flexible.

In `MapBot` a trait is just passing another factory definition as the second argument for `MapBot.build/2`.

```elixir
YourApp.Factory.build(YourApp.Car, [:greenish, model: "Sport"])
# => %YourApp.Car{model: "Sport", color: :green}
```

In the previous example we are:

1. building a map based on **YourApp.Car** factory definition;
2. then merge the result with the factory defition for **:greenish**;
3. finally merge the result again with `[model: "Sport"]`

## Installation

Check out `map_bot` dependency version on [map_bot hex](https://hex.pm/packages/map_bot).

Change your `mix.exs` to add `map_bot` with the correct version:

```elixir
def deps do
  [
    {:map_bot, "~> 0.1.1"}
  ]
end
```

## Examples:

```elixir
YourApp.Factory.build(:tomato)
# => %{name: "Tomato", color: :red}

YourApp.Factory.build(:tomato, color: :green)
# => %{name: "Tomato", color: :green}

YourApp.Factory.build(YourApp.Car, color: :yellow)
# => %YourApp.Car{model: "SUV", color: :yellow}

YourApp.Factory.build(YourApp.Car, %{color: :yellow})
# => %YourApp.Car{model: "SUV", color: :yellow}

YourApp.Factory.build(YourApp.Car, [:greenish, model: "Sport"])
# => %YourApp.Car{model: "Sport", color: :green}

YourApp.Factory.build(YourApp.Car, [:with_code])
# => %YourApp.Car{model: "SUV", color: :black, code: "CODE-123"}
```

## Documentation

The `MapBot` documentation are [available here](https://hexdocs.pm/map_bot/).

## Development

Check out the `Makefile` for useful development tasks.
