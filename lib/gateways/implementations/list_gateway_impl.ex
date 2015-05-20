defmodule ListGateway do
  @moduledoc """
  In memory implementation of the [Gateway](Gateway.html)-protocol.

  ListGateway uses a simple List to hold it's entries. Where an entry
  can be of any datatype you want.

  #### Usage:

      gw = %ListGateway{}                  # empty
      gw = %ListGateway{entries: [1,2,3]}  # with default values

  """
  defstruct entries: []
end

defimpl Gateway, for: ListGateway do

  def to_list gw_impl do
    gw_impl.entries
  end

  def put gw_impl, entry do
    %ListGateway{ entries: [entry|Gateway.to_list(gw_impl)] }
  end

  def filter gw_impl, f do
    Enum.filter gw_impl.entries, f
  end

  def count gw_impl do
    Enum.count(gw_impl.entries)
  end

  def drop gw_impl do
    %ListGateway{}
  end

end



