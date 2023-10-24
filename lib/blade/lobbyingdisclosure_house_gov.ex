import Wallaby.Browser, only: [visit: 2, click: 2, all: 2, find: 2]
import Wallaby.Query, only: [link: 1, css: 1]
import Wallaby.Element, only: [ attr: 2, text: 1 ]
# import SweetXml

defmodule Blade.LobbyingdisclosureHouseGov do
  def index session, cache do
    session
    # |> index_1registrant_links(cache)
    |> index_registrants(cache)
    |> index_disclosures(cache)
  end

  defp index_registrant_links session, cache do
    File.mkdir_p (node = "#{cache}/lobbyingdisclosure.house.gov/org/links")
    session
    |> visit("https://lobbyingdisclosure.house.gov")
    |> click(link "Search Registrant Information")
    |> all(css "#templates ul li a")
    |> Enum.map(fn x -> [ attr(x, 'text'), attr(x, 'href') ] end)
    |> Enum.map(fn [heading, address] ->
      session
      |> visit(address)
      |> all(css "li.search_result a")
      |> Enum.map(fn x -> [ attr(x, 'text'), attr(x, 'href') ] end)
      |> Enum.map(&(JSON.encode! &1))
      |> Index.record_lines("#{node}/#{heading}.jsonl")
    end); session
  end

  defp index_registrants session, cache do
    links = "#{cache}/lobbyingdisclosure.house.gov/org/links"
    File.mkdir_p (node = "#{cache}/lobbyingdisclosure.house.gov/org/clients")
    File.ls(links) |> elem(1) |> Enum.map(fn n ->
      File.stream!("#{links}/#{n}")
      |> Stream.map(fn l ->
        [name, address] = JSON.decode!(l)
        clients = (session |> visit(address)
        |> find(css "table:last-child") |> all(css "tr")
        |> Enum.map(fn line -> line |> all(css "td") |> Enum.map(& text &1) end)) |> Enum.drop(2)
        |> Enum.map(fn [n, id] -> [ name: n, id: id ] end )
        ([ org: name, clients: clients ] |> JSON.encode!) <> "\n"
      end)
      |> Stream.into(File.stream!("#{node}/#{n}"))
      |> Stream.run()
    end); session
  end

  defp index_disclosures session, cache do
    session
    |> visit("https://lobbyingdisclosure.house.gov")
    |> click(link "Lobbying Disclosure/Contributions Search")
  end
end
