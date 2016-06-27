defmodule Qlib.Configuration do
  	require Record
  	def server_name do
    	"foo"
  	end

  	# or if you prefer having it all on one line
  	def host_name, do: "example.com"

  	@type qlib_request :: record(:qlib_request, key: {:erlang.timestamp(), String.t()}, message: binary, queueName: String.t())
  	Record.defrecord :qlib_request, key: :nil, message: :nil, queueName: :nil

  	defmacro end_of_table do
   		:'$end_of_table'
  	end
end