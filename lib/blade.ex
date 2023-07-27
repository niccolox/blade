defmodule Blade do
  @moduledoc """
  `Blade` scrapes online producciones.
  """

  def start _type, _args do
    Wallaby.start_session()
    |> elem(1)
    |> Blade.ArchiveOrg.pull_record("https://archive.org/details/voyagingonsmalli0000hill")
    |> Wallaby.stop
  end
end
