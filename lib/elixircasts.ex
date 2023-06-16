import Wallaby.Browser, only: [visit: 2, click: 2, all: 2, find: 2]
import Wallaby.Query, only: [link: 1, css: 1]
import Wallaby.Element, only: [ attr: 2 ]
import SweetXml

defmodule ElixirCasts do
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
