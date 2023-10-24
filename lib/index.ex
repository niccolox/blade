defmodule Index do
  def choose index, lambda do
    index
    |> Enum.filter(lambda)
    |> Enum.map(fn episode -> episode[:address] end)
  end

  def record body, node do
    File.open!(node, [:write], fn cache ->
      IO.binwrite cache, body
      File.close cache
      body
    end)
  end

  # {:error, :enoent} ->
  #   IO.puts "Seems like your cache is read-only!"

  def record_lines body, node do
    body |> Enum.join("\n") |> record(node)
  end

  def record_blob body, node do
    JSON.encode(body) |> elem(1) |> record(node)
  end
end
