defmodule Qlib.Configuration do
  require Record

  @type qlib_request :: record(:qlib_request, key: {:erlang.timestamp(), String.t()}, message: binary, queueName: String.t())
  Record.defrecord :qlib_request,
    key: :nil,
    message: :nil,
    queueName: :nil

  defmacro end_of_table do
    :'$end_of_table'
  end

  defmacro qlib_queue do
    :qlib_queue
  end
  
end
