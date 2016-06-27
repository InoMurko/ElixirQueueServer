defmodule EqueueServer.Mixfile do
  use Mix.Project

  def project do
    [app: :equeue_server,
     version: "0.1.0",
     elixir: "~> 1.3",
     deps: deps()]
  end
  
  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [mod: {EqueueServer, []},
    applications: [:qserver, :qlib]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:ranch, "~> 1.2.1"},
    {:qlib, in_umbrella: true}]
  end
end
