import Wallaby.Browser, only: [visit: 2, click: 2, all: 2, find: 2]
import Wallaby.Query, only: [css: 1]
import Wallaby.Element, only: [ attr: 2 ]
# import SweetXml

defmodule Blade.UscodeHouseGov do
  def index session do
    session |> index_releases |> index_statues
  end

  defp index_releases session do
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

  defp index_statues session do
    File.mkdir_p "cache/uscode.house.gov/statutes"
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
        (place = "cache/uscode.house.gov/statutes/#{year}/#{issue}/index.html")
                 |> Path.dirname
                 |> File.mkdir_p
        IO.puts place
        session |> visit(address) |> find(css "table.table3act") |> attr("outerHTML")
        |> Binary.split(<<"\n">>)
        |> Index.record_lines(place)
        # |> String.replace("\n", "\n")
      end)
    end)
  end
end
