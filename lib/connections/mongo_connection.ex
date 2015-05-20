defmodule MongoConnection do
  @moduledoc """
  ##
  Start and access the global Mongo Connection -set up by Repox.config-
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

  def collection db, coll_name do
    Mongo.Db.collection(db, coll_name)
  end

  def drop collection do
    case Mongo.Collection.drop(collection) do
      _ -> nil # ignore non existing collections
    end
  end
end


