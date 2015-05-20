defmodule MongoConnectionTest do
  use ExUnit.Case, async: true

  setup do
    mongo      = Repox.config(:mongo)
    db         = Repox.config(:db)
    collection = MongoConnection.collection(db,"mongo_connection_test")

    MongoConnection.drop collection

    {:ok, mongo: mongo,
          db:    db,
          collection: collection
    }
  end


  test "Connect to mongo",  context do
    assert %Mongo.Server{ host: _host, port: _port } = context[:mongo]
  end

  test "Insert entries", context do
    [
      %{ id: 1, value: "one" },
      %{ id: 2, value: "two" }
    ]
      |> MongoConnection.insert(context[:collection])
    assert 2 == Mongo.Collection.count!(context[:collection])
  end

end
