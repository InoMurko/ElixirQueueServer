defmodule EqueueServerTest do
  use ExUnit.Case, async: false
  doctest EqueueServer

  setup do
    {:ok, pid} = ExUni.start()
    {:ok, [pid: pid]}
  end

  test "the truth", context do
    assert 1 + 1 == 2
  end
end
