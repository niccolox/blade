defmodule Blade do
  @moduledoc """
  Documentation for `Blade`.
  """

  def start _type, _args do
    index_elixircasts()
  end

  defp index_elixircasts do
    {:ok, session} = Wallaby.start_session()
    index = ElixirCasts.index session

    File.mkdir_p "cache/elixircasts"
    index
    |> Index.record_blob("cache/elixircasts/episode.index")

    open = index |> Index.choose(fn episode -> !episode[:locked] end)
    open |> Index.record_lines("cache/elixircasts/open.index")

    index
    |> Index.choose(fn episode -> episode[:locked] end)
    |> Index.record_lines("cache/elixircasts/closed.index")

    open
    |> Enum.map(fn addr -> session |> ElixirCasts.source(addr) end)
    |> Index.record_lines("cache/elixircasts/source.index")

    Wallaby.stop session
  end
end
