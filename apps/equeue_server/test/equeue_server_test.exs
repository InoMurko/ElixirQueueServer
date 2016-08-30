defmodule EqueueServerTest do
  use ExUnit.Case
  doctest EqueueServer

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "fifo", context do
    :ok = QlibApi.add("OneAndOnly", "Message1")
    :ok = QlibApi.destroy("OneAndOnly")
    :ok = QlibApi.add("OneAndOnly", "Message")
    :ok = QlibApi.add("JustOne", "Message")
    :ok = QlibApi.add("owner1", "Message")
    :ok = QlibApi.add("owner2", "TestMessage")
    :ok = QlibApi.add("owner2", "TestMessage22221")
    :ok = QlibApi.add("owner1", "Message")
    :ok = QlibApi.add("owner2", "TestMessage22222")
    :ok = QlibApi.add("owner1", "Message")
    :ok = QlibApi.add("OneAndOnly", "Message2")
    :ok = QlibApi.add("owner2", "TestMessage22223")
    assert "Message" == QlibApi.get("owner1")
    assert "TestMessage" == QlibApi.get("owner2")
    assert "TestMessage22221" == QlibApi.get("owner2")
    assert "TestMessage22222" == QlibApi.get("owner2")
    assert "TestMessage22223" == QlibApi.get("owner2")
    assert "Message" == QlibApi.get("owner1")
    :ok = QlibApi.add("owner2", "TestMessage")
    assert "Message" == QlibApi.get("owner1")
    assert "TestMessage" == QlibApi.get("owner2")
    assert :'$end_of_table' == QlibApi.get("owner1")
    assert :'$end_of_table' == QlibApi.get("owner2")
    :ok = QlibApi.destroy("OneAndOnly")
    :ok = QlibApi.destroy("JustOne")
    :ok = QlibApi.destroy("JustNothing")
    assert :'$end_of_table' == QlibApi.get("OneAndOnly")
    assert :'$end_of_table' == QlibApi.get("JustOne")
    assert [] == :ets.tab2list(:qlib_queue)
  end
  
end
