defmodule QlibDB do
  require Qlib.Configuration, as: C

  ## TODO Add comment about the logaritmic perfomance of using Mnesia
  ## ordered_sets
  ###===================================================================
  ### API
  ###===================================================================
  @spec table_definitions :: [{atom(), atom(), [{:type, :ets.type()}]}]
  def table_definitions do
    [{C.queue_table, :qlib_request, [{:type, :ordered_set}]}]
  end

  @spec create_tables() :: :ok
  def create_tables do
    for definition <- table_definitions, do: {:atomic, :ok} = create_table(definition)
    :ok
  end

  @spec delete_tables :: :ok
  def delete_tables do
    for {name, _rec, _opts} <- table_definitions, do: :mnesia.delete_table(name)
    :ok
  end
  
  @spec remove_all(String.t) :: :ok
  def remove_all(_queue) do
    :ok
  end

  @spec create_table({:mnesia.tab(), atom(), list()}) :: {:atomic, :ok} | tuple()
  defp create_table({table, record, options}) do
    case :mnesia.create_table(table, [{:record_name, record}, {:attributes,
							       Dict.keys(record.__record__(:fields))}] ++ options) do
    {:atomic, :ok} ->
	{:atomic, :ok};
      {:aborted, e} ->
	raise(e, [{table, options}])
    end
  end

end
