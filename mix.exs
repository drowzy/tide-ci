defmodule Tide.Mixfile do
  use Mix.Project

  def project do
    [
      app: :tide_ci,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Tide, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:poison, "~> 3.0"},
      {:httpoison, "~> 0.12"},
      {:cowboy, "~> 1.1.2"},
      {:plug, "~> 1.4.3"},
      {:git_cli, "~> 0.2"},
      {:temp, "~> 0.4", only: :test},
      {:bypass, "~> 0.8", only: :test},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:dogma, "~> 0.1", only: [:dev]}
    ]
  end
end
