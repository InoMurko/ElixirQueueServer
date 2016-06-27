defmodule EqueueServer do
  use Application

  def start(_type, _args) do
    port = Application.fetch_env!(:qserver, :ranch_port)
  	{ :ok, _ } = :ranch.start_listener(:tcp_echo, 1, :ranch_tcp, [port: port], QServerProtocolProc, [])
  end
end
