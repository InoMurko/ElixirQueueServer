defmodule EqueueServer do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    port = Application.fetch_env!(:equeue_server, :ranch_port)
    { :ok, _ } = :ranch.start_listener(:tcp_echo, 1, :ranch_tcp,
      [port: port], QServerProtocolProc, [])
    opts = [strategy: :one_for_one, name: EqueueServer.Supervisor]
    Supervisor.start_link([], opts)
  end
end
