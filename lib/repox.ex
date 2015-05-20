defmodule Repox do
  require Logger

  @moduledoc """
  Repox Main Module

  The aim of this 'main-module' is to provide a convenient way to
  configure the application. See [README#configuration](README.html#Configuration).
  """

  use Mix.Config

  # APPLICATION API

  @doc """
  Start a Repox Application.

  It starts an Elixir.Agent, holding the status of single MongoDB-connection.

  Returns {:ok, agent}

  **Don't call directly** it is configured in `mix.exs :applications`
  """
  def start :normal, [] do
    {:ok, agent} = start_agents
    {:ok, agent}
  end

  @doc """
  Retreive settings from config-agent. See start_agents/0.

  Configurations read from config-files (Application.get_env...)
  see files `config/_ENV_.exs`
      mongo: _mongo_connection_,
      db: _db_
  """
  def config key do
    Agent.get(:config, fn(cfg) -> cfg[key] end)
  end

  @doc "Get the entire configuration set"
  def config do
    Agent.get(:config, fn(cfg) -> cfg end)
  end

  # private API

  defp start_agents do
    {:ok, mongo, db} = Mongo.connect! |> select_db
    {:ok, agent}     = Agent.start_link fn ->
                        [
                          mongo: mongo,
                          db:    db
                        ] end,
                       name: :config
    {:ok, agent}
  end

  defp select_db mongo do
    db = Mongo.db(mongo, Application.get_env(:repox, :mongo_db_name))
    {:ok, mongo, db}
  end

end
