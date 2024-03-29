defmodule Blade.MixProject do
  use Mix.Project

  def project do
    [
      app: :blade,
      version: "0.0.2",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
    ]
  end

  def application do
    [
      mod: { Blade, [] },
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:binary, "~> 0.0" },
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:json, "~> 1.4"},
      {:sweet_xml, "~> 0.7"},
      {:wallaby, "~> 0.30"},
    ]
  end

  defp description do
    "`blade` is a collección de scraping programs across a number de online domains. Replacing and picking up in þe place `code/reap` has ended."
  end

  defp package do
    [
      name: "blade",
      files: ~w( lib mix.exs README.md ),
      licenses: ["Unlicense"],
      links: %{ "Source" => "https://base.bingo/code/blade" },
    ]
  end
end
