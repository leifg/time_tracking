defmodule TimeTracking.Mixfile do
  use Mix.Project

  def project do
    [app: :time_tracking,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {TimeTracking, []},
     applications: [:phoenix, :cowboy, :logger, :timex  ]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.0"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:exvcr, "~> 0.7", only: :test},
     {:cowboy, "~> 1.0"},
     {:httpoison, "~> 0.9"},
     {:plug_basic_auth, "~> 1.1"},
     {:timex, "~> 2.2"}]
  end
end
