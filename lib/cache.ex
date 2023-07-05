defmodule Cache do
  def make node, call do
    case File.exists? node do
      true -> File.read node
      false -> Index.record call.(), node
    end
  end
end
