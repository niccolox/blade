defmodule Index do
  def choose index, lambda do
    index
    |> Enum.filter(lambda)
    |> Enum.map(fn episode -> episode[:address] end)
  end

  def record body, node do
    {:ok, cache} = File.open(node, [:write])
    IO.binwrite cache, body
    File.close cache
    body
  end

  def record_lines body, node do
    body
    |> Enum.join("\n")
    |> record(node)
  end

  def record_blob body, node do
    JSON.encode(body)
    |> elem(1)
    |> record(node)
  end
end
