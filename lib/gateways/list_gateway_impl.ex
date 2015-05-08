defmodule ListGateway do
  @moduledoc """
  In memory implementation of the [Gateway](Gateway.html)-protocol.

  ListGateway uses a simple List to hold it's entries. Where an entry
  can be of any datatype you want.

  """
  defstruct entries: []
end

defimpl Gateway, for: ListGateway do

  def to_list gw_impl do
    Enum.to_list gw_impl.entries
  end

  def put gw_impl, entry do
    %ListGateway{ entries: [entry|Gateway.to_list(gw_impl)] }
  end

  def filter gw_impl, f do
    Enum.filter gw_impl.entries, f
  end
end



