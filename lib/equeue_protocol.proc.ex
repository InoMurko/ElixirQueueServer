defmodule QServerProtocolProc do
	use GenServer
	require Record
  	@break "\r\n"

	def start_link(ref, socket, transprot, opts) do
		:proc_lib.start_link(__MODULE__, :init, [ref, socket, transprot, opts])
	end

	def init([]) do
		{:ok, :undefined}
	end

	def init(ref, socket, transport, _opts) do
	    :ok = :proc_lib.init_ack({:ok, self()})
	    :ok = :ranch.accept_ack(ref)
	    :ok = transport.setopts(socket, [active: :once, packet: :line])
	    :gen_server.enter_loop(__MODULE__, [], %{socket: socket, 
	    		transport: transport, 
	    		queue: :crypto.rand_bytes(16) 
	    			|> Base.encode64 
	    			|> to_string})
	end

	def handle_cast(_, state) do
	    {:noreply, state}
  	end

    def handle_info({:tcp, socket, message}, state = %{socket: socket, transport: transport}) do
	    :ok = transport.setopts(socket, active: :once)
	    :ok = split_and_process(message, state)
	    {:noreply, state}
    end

    def handle_info({:tcp_closed, _socket}, state) do
	    {:stop, :normal, state}
    end

	defp split_and_process(message, state) do
		split(:binary.split(message, @break), state)
	end

	defp split([<<"out">> | [tail]], state = %{socket: socket, transport: transport, queue: queue}) do
		case QlibApi.get(queue) do
			@end_of_table ->
				transport.setopts(socket, [active: :once])
				transport.send(socket, [])
			item ->
				transport.setopts(socket, [active: :once])
				transport.send(socket, <<item :: binary, @break :: binary>>)
		end
		split(:binary.split(tail, @break), state)
	end
	defp split([<<_in :: 16, payload :: binary >> = _Message | [tail]], state = %{queue: queue}) do
		:ok = QlibApi.add(queue, payload)
		split(:binary.split(tail, @break), state)
	end
	defp split([<<>>], _state) do
		:ok
	end
end
