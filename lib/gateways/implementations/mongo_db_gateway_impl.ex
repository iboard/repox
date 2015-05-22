defmodule MongoDBGateway do
  @moduledoc """
  MongoDB implementation of the [Gateway](Gateway.html)-protocol.

  #### Usage:

      gw = %MongoDBGateway{db: "test", collection: "test"}
  """
  defstruct db: "test", collection: "test", mongo: nil
end

defimpl Gateway, for: MongoDBGateway do
  def to_list gw_impl do
    collection = gw_impl.mongo
      |> Mongo.db(gw_impl.db)
      |> Mongo.Db.collection(gw_impl.collection)
    Mongo.Collection.find(collection) |> Enum.map( fn(e) ->
      Map.delete(e, :_id)
    end)
  end

  def put gw_impl, entry do
    collection = gw_impl.mongo
      |> Mongo.db(gw_impl.db)
      |> Mongo.Db.collection(gw_impl.collection)
    [entry]    |> Mongo.Collection.insert(collection)
    gw_impl
  end

  def filter gw_impl, f do
    Enum.filter Gateway.to_list(gw_impl), f
  end

  def count gw_impl do
    gw_impl.mongo
      |> Mongo.db(gw_impl.db)
      |> Mongo.Db.collection(gw_impl.collection)
      |> Mongo.Collection.count!
  end

  def drop gw_impl do
    collection = gw_impl.mongo
      |> Mongo.db(gw_impl.db)
      |> Mongo.Db.collection(gw_impl.collection)
    MongoConnection.drop(collection)
    gw_impl
  end

  def find gw_impl, id do
    case filter(gw_impl, &(&1.id == id)) do
      [found|_] -> found
      []        -> :not_found
    end
  end

end



