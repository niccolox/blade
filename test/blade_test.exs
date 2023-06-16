defmodule BladeTest do
  use ExUnit.Case
  doctest Blade

  test "greets the world" do
    assert Blade.hello() == :world
  end
end
