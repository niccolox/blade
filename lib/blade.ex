defmodule Blade do
  @moduledoc """
  `Blade` scrapes online producciones.
  """

  def start _type, _args do
    Wallaby.start_session() |> elem(1)
    |> Blade.UscodeHouseGov.index
    |> Wallaby.stop
  end
end
