defmodule QlibApi do
  require Qlib.Configuration, as: C

  @doc """                                                                                                                                                                                           
  Creates the necessary Mnesia tables.
  """
  @spec create_tables() :: :ok
  def create_tables do
    QlibDB.create_tables
  end

  @doc """                                                                                                                                                                                             
  Deletes the created Mnesia tables
  """
  @spec delete_tables() :: :ok
  def delete_tables do
    QlibDB.delete_tables
  end

  @doc """
  Adds a new entry to the FIFO queue.
  This operation is O(logn) at the moment. 
  """
  @spec add(String.t, binary()) :: :ok
  def add(queue, msg) do
    id = queue
    QlibDB.add(C.qlib_queue, id, queue, msg)
  end

  @doc """
  Gets a entry from the FIFO queue.
  """
  @spec get(String.t) :: :'$end_of_table' | binary()
  def get(owner) do
    QlibDB.first_select(C.qlib_queue, owner)
  end
  
  @doc """
  Remove all queue entries.                                                                   
  """  
  def destroy(owner) do
    QlibDB.remove_all(C.qlib_queue, owner)
  end
end
