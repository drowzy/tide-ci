defmodule TideTest do
  use ExUnit.Case
  doctest Tide

  test "greets the world" do
    assert Tide.hello() == :world
  end
end
