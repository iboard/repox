defmodule MongoConnection do
  @moduledoc """
  Start and access the global Mongo Connection

  Set up see [Repox.config](Repox.html)
  """

  @doc "Get global mongo connection"
  def start _opts do
    mongo = Repox.config(:mongo)
    {:ok, mongo}
  end

  @doc "Insert data to a mongo collection"
  def insert data, collection do
    Mongo.Collection.insert!(data, collection)
  end

  @doc "Return the named collection in db"
  def collection db, coll_name do
    Mongo.Db.collection(db, coll_name)
  end

  @doc "Drop the given collection from db"
  def drop collection do
    case Mongo.Collection.drop(collection) do
      _ -> nil # ignore non existing collections
    end
  end

  @doc "Inspect the Status of the connection"
  def status do
    "MONGO DB CONNECTION: " <> inspect(Repox.config(:mongo))
  end
end


