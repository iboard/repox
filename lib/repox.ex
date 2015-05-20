defmodule Repox do
  @moduledoc """
  This is a project under heavy development.
  for now, please read [README](README.html)
  """

  use Mix.Config

  @doc """
  Start a Repox Application.
  It starts an Elixir.Agent, holding the status of single MongoDB-connection.
  Returns {:ok, agent}
  """
  def start :normal, [] do
    {:ok, mongo} = Mongo.connect
    db =         Mongo.db(mongo, Application.get_env(:repox, :mongo_db_name))
    {:ok, agent} = Agent.start_link fn ->
                     [
                       mongo: mongo,
                       db: db
                     ] end, name: :config
    {:ok, agent}
  end


  @doc """
  Retreive stuff setup in start :normal. The configuration can be done
  in `config/ENV.exs`
      mongo: _mongo_connection_,
      db: _db_
  """
  def config key do
    Agent.get(:config, fn(cfg) -> cfg[key] end)
  end
end
