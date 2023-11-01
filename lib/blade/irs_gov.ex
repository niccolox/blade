import Wallaby.Browser, only: [visit: 2, click: 2, all: 2, find: 2, set_value: 3]
import Wallaby.Query, only: [link: 1, css: 1, button: 1, all: 1]
import Wallaby.Element, only: [ attr: 2, text: 1 ]

defmodule Blade.IrsGov do
  alias Wallaby.Query

  def index session, cache do
    session
    |> index_forms(cache)
  end

  defp index_forms session, cache do
    File.mkdir_p (node = "#{cache}/irs.gov/forms")

    session
    |> visit("https://www.irs.gov/forms-instructions-and-publications")
    # import IEx; IEx.pry

    lines = session |> combine_pages(fn page ->
      page
      |> all(css "table tbody tr")
      |> Enum.map(fn line -> [
        (line |> find(css "td:first-child a") |> attr("href"))
        | (line |> all(css "td") |> Enum.map(&text/1))
      ] end)
    end)
    |> Enum.map(&(JSON.encode! &1))
    |> Index.record_lines("#{node}/index.jsonl")
  end

  defp combine_pages(session, call) do
    lines = call.(session)
    combine_pages(click_proceed(session), call, lines)
  end
  defp combine_pages(nil, call, lines), do: lines
  defp combine_pages(session, call, lines) do
    lines = call.(session) ++ lines
    combine_pages(click_proceed(session), call, lines)
  end

  defp click_proceed(session) do
    try do
      address = session |> find(css "a[rel=\"next\"]") |> attr("href")
      session |> visit(address)
    rescue
      e in Wallaby.QueryError ->
        IO.inspect(e, label: "no more pages")
        nil
    end
  end
end
