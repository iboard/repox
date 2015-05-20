defmodule GatewayTest do
  use ExUnit.Case, async: false
  doctest Gateway

  @empty_testfile          "/tmp/#{__MODULE__}.empty.json"
  @filled_testfile         "/tmp/#{__MODULE__}.filled.json"
  @empty_mongo_collection  "test_empty"
  @filled_mongo_collection "test_filled"

  setup do
    # return empty and filled gateways for each gateway implementation.
    # Running the same test for each implementation ensures they behaves the same.
    seed = [
             %{id: 1, value: "one"},
             %{id: 2, value: "two"},
             %{id: 3, value: "three"}
           ]

    # Setup files and collections
    compose_test_files seed
    mongo  = Repox.config(:mongo)
    db     = Repox.config(:db)
    compose_mongo_collections seed

    # Setup empty and filled gateways for all tests
    empty  = [ %ListGateway{},
               %FileGateway{path: @empty_testfile},
               %MongoDBGateway{mongo: mongo, collection: @empty_mongo_collection}]

    filled = [ %ListGateway{entries: seed},
               %FileGateway{path: @filled_testfile},
               %MongoDBGateway{mongo: mongo, collection: @filled_mongo_collection}]

    # Teardown and empty Gateways
    on_exit fn ->
      Enum.each(empty, fn(gw) ->
        Gateway.drop(gw)
      end)
    end
    {:ok, empty: empty, filled: filled, seed: seed}
  end

  # TESTS

  test "Gateway.to_list(gw) returns all entries as a list", context do
    Enum.each context[:empty], fn(gw) ->
      assert [] == Gateway.to_list(gw)
    end
  end

  test "Gateway.put(gw,entry) put something into the gateway", context do
    Enum.each context[:empty], fn(gw) ->
      new_gw = Gateway.put(gw, %{key: 'value'})
      assert [%{key: 'value'}] == Gateway.to_list(new_gw)
    end
  end

  test "Gateway.filter(gw,fn) filters entries with a function", context do
    expected = Enum.take(context[:seed], 2)
    Enum.each context[:filled], fn(gw) ->
      assert expected == Gateway.filter( gw, &(&1.id <= 2) )
    end
  end

  # Private API

  defp compose_test_files seed do
    empty_json  = Poison.Encoder.encode([], [])
    filled_json = Poison.Encoder.encode(seed, [])
    File.write!(@filled_testfile, filled_json)
    File.write!(@empty_testfile, empty_json)
  end

  defp compose_mongo_collections seed do
    db                = Repox.config(:db)
    empty_collection  = MongoConnection.collection(db,@empty_mongo_collection)
    filled_collection = MongoConnection.collection(db,@filled_mongo_collection)

    MongoConnection.drop empty_collection
    MongoConnection.drop filled_collection

    seed |> MongoConnection.insert(filled_collection)
  end

end
