defmodule GatewayTest do
  use ExUnit.Case
  doctest Gateway

  setup do
    all = [
      %{id: 1, value: "one"},
      %{id: 2, value: "two"},
      %{id: 3, value: "three"} ]
    empty  = [ %ListGateway{} ]
    filled = [ %ListGateway{ entries: all } ]
    {:ok, data: all, empty: empty, filled: filled}
  end


  test "get all entries as a list", context do
    Enum.each context[:empty], fn(gw) ->
      assert [] == Gateway.to_list(gw)
    end
  end

  test "put something to the list", context do
    Enum.each context[:empty], fn(gw) ->
      new_gw = Gateway.put(gw, %{key: :value})
      assert [%{key: :value}] == Gateway.to_list(new_gw)
    end
  end

  test "filter entries", context do
    expected = Enum.take(context[:data], 2)
    Enum.each context[:filled], fn(gw) ->
      assert expected == Gateway.filter( gw, &(&1.id <= 2) )
    end
  end
end
