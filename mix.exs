defmodule EqueueQlib.Mixfile do
  use Mix.Project

  def project do
    [apps_path: "apps",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

#  def application do
#    [mod: {EqueueServer, []},
#     applications: [:equeue_server, :ssl]]
#  end
  
  defp deps do
    [{:ranch, "~> 1.2.1"}] 
   end
end
