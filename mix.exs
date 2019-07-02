defmodule TimeTracking.Mixfile do
  use Mix.Project

  def project do
    [
      app: :time_tracking,
      version: "0.0.0-development",
      elixir: "~> 1.0",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [extra_applications: [:logger], mod: {TimeTracking, []}]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_), do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:exvcr, "~> 0.10", only: :test},
      {:cowboy, "~> 1.0"},
      {:httpoison, "~> 1.1"},
      {:plug_basic_auth, "~> 1.1"},
      {:timex, "~> 3.2"},
      {:distillery, "~> 2.1"}
    ]
  end
end
