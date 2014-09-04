defmodule ParsEx.Mixfile do
  use Mix.Project

  def project do
    [app: :parsex,
     version: "0.0.2",
     elixir: "~> 1.0.0-rc2",
     deps: deps,
     package: [
       contributors: ["Jeremy Lyman"],
       licenses: ["MIT"],
       links: [github: "https://github.com/maarek/ParsEx"]
     ],
     description: """
     ParsEx is an Elixir HTTP Client for communicating with Parse.com's Restful API
     """
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :poison, :httpoison]]
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
      {:poison, "~> 1.1.0"},
      {:httpoison, "~> 0.4"}
    ]
  end
end
