import Wallaby.Browser, only: [visit: 2, click: 2, all: 2, find: 2]
import Wallaby.Query, only: [link: 1, css: 1]
import Wallaby.Element, only: [ attr: 2 ]
import SweetXml

defmodule Blade.ElixirCasts do
  defp record session do
    File.mkdir_p "cache/elixircasts"
    index = session |> index
    index |> Index.record_blob("cache/elixircasts/episode.index")
    index
    |> Index.choose(fn episode -> episode[:locked] end)
    |> Index.record_lines("cache/elixircasts/closed.index")

    open = index |> Index.choose(fn episode -> !episode[:locked] end)
    open |> Index.record_lines("cache/elixircasts/open.index")
    open
    |> Enum.map(fn addr -> session |> source(addr) end)
    |> Index.record_lines("cache/elixircasts/source.index")
  end

  def index session do
    session
    |> visit("https://elixircasts.io")
    |> click(link "All Episodes")
    |> all(css "a.block")
    |> Enum.map(fn x -> attr(x, 'outerHTML') end)
    |> Enum.map(&([
      address:  &1 |> xpath(~x"//@href"s),
      locked: &1 |> xpath(~x"//div/div/span/text()"s) |> String.trim() == "Alchemist's Edition",
    ]))
  end

  def source session, address do
    session
    |> visit(Path.join "https://elixircasts.io", address)
    |> find(css "iframe.embed-responsive-item")
    |> attr("src")
  end
end
