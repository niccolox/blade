import Wallaby.Browser, only: [visit: 2, click: 2, all: 2, find: 2]
import Wallaby.Query, only: [link: 1, css: 1]
import Wallaby.Element, only: [ attr: 2 ]
# import SweetXml

defmodule Blade.UscodeHouseGov do
  def index session, cache do
    File.mkdir_p "#{cache}/uscode.house.gov/statutes"
    session
    |> index_statutes_volume(cache)
    |> index_statutes_year(cache)
    |> index_releases(cache)
  end

  defp index_releases session, cache do
    session
    |> visit("https://uscode.house.gov")
    # |> click(link "Other OLRC Tables and Tools")
    # import IEx; IEx.pry

    # |> Enum.map(fn x -> attr(x, 'outerHTML') end)
    # |> Enum.map(&([
    #   address:  &1 |> xpath(~x"//@href"s),
    #   locked: &1 |> xpath(~x"//div/div/span/text()"s) |> String.trim() == "Alchemist's Edition",
    # ]))
  end

  defp index_statutes_year session, cache do
    IO.puts "Indexing years."
    session
    |> visit("https://uscode.house.gov")
    |> click(css "div#item_OTHER_TABLES_TOOLS")
    |> click(css "div#item_TABLEIII")
    |> all(css "div.alltable3years > span > a")
    |> Enum.map(fn x -> [ attr(x, 'text'), attr(x, 'href') ] end)
    |> Enum.map(fn [year, address] ->
      session |> visit(address) |> all(css "div.yearmaster > span > a")
      |> Enum.map(fn x -> [ attr(x, 'text'), attr(x, 'href') ] end)
      |> Enum.map(fn [issue, address] ->
        place = "#{cache}/uscode.house.gov/statutes/index.year/#{year}/#{issue}.html"
        Cache.make place, fn ->
          place |> Path.dirname |> File.mkdir_p; IO.puts "Caching: " <> place;
          session |>
          visit(address) |>
          find(css "table.table3act")
          |> attr("outerHTML")
          |> Binary.split(<<"\n">>)
          |> Index.record_lines(place)
        end
      end)
    end)
    session
  end

  defp index_statutes_volume session, cache do
    IO.puts "Indexing volumes."
    session
    |> visit("https://uscode.house.gov")
    |> click(css "div#item_OTHER_TABLES_TOOLS")
    |> click(css "div#item_TABLEIII")
    |> click(link "Statutes at Large Volumes")
    |> all(css "div.alltable3statutesatlargevolumes > span > a")
    |> Enum.map(fn x -> [ attr(x, 'text'), attr(x, 'href') ] end)
    |> Enum.map(fn [volume, address] ->
      session |> visit(address) |> all(css "div.statutesatlargevolumemaster > span > a")
      |> Enum.map(fn x -> [ attr(x, 'text'), attr(x, 'href') ] end)
      |> Enum.map(fn [issue, address] ->
        place = "#{cache}/uscode.house.gov/statutes/index.volume/#{volume}/#{issue}.html"
        Cache.make place, fn ->
          place |> Path.dirname |> File.mkdir_p; IO.puts "Caching: " <> place;
          session
          |> visit(address)
          |> find(css "table.table3act")
          |> attr("outerHTML")
          |> Binary.split(<<"\n">>)
          |> Index.record_lines(place)
        end
      end)
    end); session
  end
end
