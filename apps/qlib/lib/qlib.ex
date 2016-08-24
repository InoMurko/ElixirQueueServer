defmodule QLib do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    :mnesia.create_schema([node()])
    QlibApi.create_tables()
    # Define workers and child supervisors to be supervised
    children = [
    ]
    opts = [strategy: :one_for_one, name: QLib.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
