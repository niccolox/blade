defmodule Blade do
  @moduledoc """
  `Blade` scrapes online producciones.
  """

  def start _type, _args do
    # cache = "~/.cache.channel"
    cache = "cache.local"

    Wallaby.start_session() |> elem(1)
    |> Blade.IrsGov.index(cache)
    # |> Blade.LobbyingdisclosureHouseGov.index(cache)
    # |> Blade.UscodeHouseGov.index(cache)
    |> Wallaby.stop
  end
end
