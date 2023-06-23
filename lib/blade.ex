defmodule Blade do
  @moduledoc """
  Documentation for `Blade`.
  """

  def start _type, _args do
    Wallaby.start_session() |> elem(1) |> Blade.UscodeHouseGov.index |> Wallaby.stop
  end

  defp index_elixircasts(session) do
    File.mkdir_p "cache/elixircasts"

    index = session |> ElixirCasts.index

    index |> Index.record_blob("cache/elixircasts/episode.index")

    index
    |> Index.choose(fn episode -> episode[:locked] end)
    |> Index.record_lines("cache/elixircasts/closed.index")

    open = index |> Index.choose(fn episode -> !episode[:locked] end)
    open |> Index.record_lines("cache/elixircasts/open.index")
    open
    |> Enum.map(fn addr -> session |> ElixirCasts.source(addr) end)
    |> Index.record_lines("cache/elixircasts/source.index")
  end
end
