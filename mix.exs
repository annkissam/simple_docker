defmodule SimpleDocker.Mixfile do
  use Mix.Project

  @version "0.1.0"
  @url "https://github.com/annkissam/simple_docker"

  def project do
    [
      app: :simple_docker,
      version: @version,
      elixir: "~> 1.4.2",
      deps: deps(),
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,

      # Test
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test],
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env),

      # Hex
      description: description(),
      package: package(),

      # Docs
      name: "SimpleDocker",
      docs: docs(),
    ]
  end

  def application do
    [
      applications: [
        :logger
      ],
    ]
  end

  def package do
    [
      files: ["lib", "mix.exs", "README.md"],
      maintainers: ["Adi Iyengar"],
      licenses: ["MIT"],
      links: %{"Github" => @url},
    ]
  end

  defp deps do
    [
      {:credo, "~> 0.5", only: [:dev, :test]},
      {:excoveralls, "~> 0.3", only: :test},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:inch_ex, "~> 0.5", only: [:dev, :test, :docs]},
    ]
  end

  defp description do
    """
    A lightweight interface that allows us to run docker commands through elixir
    """
  end

  def docs do
    [
      main: "SimpleDocker",
      source_url: @url,
      source_ref: "v#{@version}"
    ]
  end

  defp aliases do
    []
  end

  defp elixirc_paths(:test), do: ["lib", "priv", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]
end
