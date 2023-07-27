import Wallaby.Browser, only: [visit: 2, click: 2, all: 2, find: 2, fill_in: 3]
import Wallaby.Query, only: [button: 1, link: 1, css: 1, text_field: 1]
import Wallaby.Element, only: [ attr: 2 ]

defmodule Blade.ArchiveOrg do
  def pull_record session, address do
    session
    |> visit(address)
    |> click(link "Log in")
    |> fill_in(text_field("Email address"), with: "...")
    |> fill_in(text_field("Password"), with: "...")
    |> click(button "Log in")

    import IEx; IEx.pry
    session
  end
end
