defmodule QlibDB do
  require Qlib.Configuration, as: C

  ## TODO Add comment about the logaritmic perfomance of using Mnesia
  ## ordered_sets
  ###===================================================================
  ### API
  ###===================================================================
  @spec table_definitions :: [{atom(), atom(), [{:type, :ets.type()}]}]
  def table_definitions do
    [{C.qlib_queue, C.qlib_request, [{:type, :ordered_set}]}]
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

  @doc """
  There's the strong assumption that only one and the same process  
  is using this function, and that writes only happen at the end of                              
  the queue! This would return the first insert, regardles of the queue name.                      
  """
  @spec first(:mnesia.tab()) :: C.end_of_table | C.qlib_request
  defp first(table) do
    case :mnesia.dirty_first(table) do
      C.end_of_table ->
	C.end_of_table
      key ->
        [qRec] = :mnesia.dirty_read(table, key)
        qRec
    end
  end
  
  @doc """
  Creates and adds an entry to one of the Mnesia table. It is added
  at the end of the ordered_set.
  """
  @spec add(:mnesia.tab(), String.t(), String.t(), binary()) :: :ok
  defp add(table, id, queue, msg) do
    key = {:os.timestamp(), id}
    qReq = C.qlib_request(key: key, message: msg, queueName: queue)
    add_record(table, qReq)
  end
  
  @spec add_record(:mnesia.tab(), C.qlib_request) :: :ok
  defp add_record(table, qRec) do
    :ok = :mnesia.dirty_write(table, qRec)
  end
  
  @spec create_table({:mnesia.tab(), atom(), list()}) :: {:atomic, :ok} | tuple()
  defp create_table({table, record, options}) do
    case :mnesia.create_table(table, [{:record_name, elem(C.qlib_request, 0)},
				      {:attributes,
				       Keyword.keys(C.qlib_request(record))}] ++ options) do
      {:atomic, :ok} ->
	{:atomic, :ok}
      {:aborted, e} ->
	raise(e, [{table, options}])
    end
  end
  
end
