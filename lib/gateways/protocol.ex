# TODO: Add complete set of functions

defprotocol Gateway do
  @moduledoc """
    The Gateway-protocol implements persistence related functions for any
    kind of 'Entries'. It knows how to store and read those entries from
    a given device, file, or just the memory.

    Implementations may be ListGateway (InMemory), FileGateway,
    and more to come MongoDBGateway,  SQLGateway, and others.

    **ATTENTION**

  >  You shall not use a Gateway directely. Instead use the
  >  [GatewayService](GatewayService.html)
  >  (The service provides the same function as the Gateway-protocol
  >  and delegates them to the used Gateway-Implementation. Where
  >  different Gateway-Implementations know how to persist entries.
  """

  @doc """
  Return all entries as a List.

  #### Example:
      iex> gw = %ListGateway{ entries: [ :hello, :world ] }
      ...> Gateway.to_list(gw)
      [:hello, :world]
  """
  @spec to_list(Gateway.t) :: List.t
  def to_list gw_impl

  @doc """
  Store a new entry

  #### Example:
      iex> gw = %ListGateway{ entries: [ :first, :second ] }
      ...> gw_modified = Gateway.put(gw, :third)
      ...> Gateway.to_list(gw_modified)
      [:third, :first, :second]
  """
  @spec put(Gateway.t, any) :: Gateway
  def put     gw_impl, entry

  @doc """
  Filter entries by _f_.
  Where _f_ should return true if entry should be in the resulting List.

  #### Example:
      iex> gw = %ListGateway{ entries: [ 1, 2, 3 ] }
      ...> Gateway.filter(gw, &(&1 > 2))
      [3]
  """
  @spec filter(Gateway.t, fun) :: List.t
  def filter  gw_impl, f

  @doc """
  Count entries in repository/gateway
  """
  @spec count(Gateway.t) :: Integer
  def count gw_impl

  @doc """
  Drop repository
  """
  @spec drop(Gateway.t) :: Gateway.t
  def drop gw_impl

  @doc "Find an entry by id"
  @spec find(Gateway.t, any) :: any
  def find gw_impl, id

end


