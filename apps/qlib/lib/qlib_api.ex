defmodule QlibApi do
	require Qlib.Configuration, as: C

	def create_tables do
		
	end

	def delete_tables do
		
	end

	@spec add(String.t, binary()) :: :ok
	def add(queue, msg) do
		
	end

	def get(owner) do
		
	end

	def destroy(owener) do
		QlibDB.remove_all(C.end_of_table)
	end
	
end