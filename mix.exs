defmodule Repox.Mixfile do
  use Mix.Project

  def project do
    [app: :repox,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     docs: [readme: "README.md", main: "README"],
     package: package,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.7", only: :dev},
      {:benchfella, "~> 0.2", only: :dev},
      {:poison, git: "git@github.com:devinus/poison.git", tag: "1.4.0" }
    ]
  end

  defp package do
    [files: ~w(lib mix.exs README.md CHANGELOG.md),
     contributors: ["Andreas Altendorfer"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/iboard/repox"}]
  end

end
