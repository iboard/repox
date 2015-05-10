defmodule GatewayTest do
  use ExUnit.Case, async: true
  doctest Gateway

  @empty_testfile "/tmp/#{__MODULE__}.empty.json"
  @filled_testfile "/tmp/#{__MODULE__}.filled.json"

  setup do
    all = [
      %{id: 1, value: "one"},
      %{id: 2, value: "two"},
      %{id: 3, value: "three"} ]

    # encode and write files
    empty_json  = Poison.Encoder.encode([], [])
    filled_json = Poison.Encoder.encode(all, [])
    File.write!(@filled_testfile, filled_json)
    File.write!(@empty_testfile, empty_json)

    # return empty and filled gateways of both kinds
    # Tests will use all gateways in empty and filled,
    # thus the same test ensures all gateways behaves the same way
    empty  = [ %ListGateway{},
               %FileGateway{path: @empty_testfile} ]
    filled = [ %ListGateway{entries: all},
               %FileGateway{path: @filled_testfile} ]

    {:ok, data: all, empty: empty, filled: filled}
  end


  test "get all entries as a list", context do
    Enum.each context[:empty], fn(gw) ->
      assert [] == Gateway.to_list(gw)
    end
  end

  test "put something to the list", context do
    Enum.each context[:empty], fn(gw) ->
      new_gw = Gateway.put(gw, %{key: 'value'})
      assert [%{key: 'value'}] == Gateway.to_list(new_gw)
    end
  end

  test "filter entries", context do
    expected = Enum.take(context[:data], 2)
    Enum.each context[:filled], fn(gw) ->
      assert expected == Gateway.filter( gw, &(&1.id <= 2) )
    end
  end
end
