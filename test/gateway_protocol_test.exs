defmodule GatewayTest do
  use ExUnit.Case, async: true
  doctest Gateway

  @empty_testfile "/tmp/#{__MODULE__}.empty.json"
  @filled_testfile "/tmp/#{__MODULE__}.filled.json"

  setup do
    seed = [
             %{id: 1, value: "one"},
             %{id: 2, value: "two"},
             %{id: 3, value: "three"}
           ]

    compose_test_files seed

    # return empty and filled gateways of both kinds
    # Tests will use seed gateways in empty and filled,
    # thus the same test ensures seed gateways behaves the same way
    empty  = [ %ListGateway{},
               %FileGateway{path: @empty_testfile} ]
    filled = [ %ListGateway{entries: seed},
               %FileGateway{path: @filled_testfile} ]

    {:ok, empty: empty, filled: filled, seed: seed}
  end


  test "Gateway.to_list(gw) returns all entries as a list", context do
    Enum.each context[:empty], fn(gw) ->
      assert [] == Gateway.to_list(gw)
    end
  end

  test "Gateway.put(gw,entry) put something into the gateway", context do
    Enum.each context[:empty], fn(gw) ->
      new_gw = Gateway.put(gw, %{key: 'value'})
      assert [%{key: 'value'}] == Gateway.to_list(new_gw)
    end
  end

  test "Gateway.filter(gw,fn) filters entries with a function", context do
    expected = Enum.take(context[:seed], 2)
    Enum.each context[:filled], fn(gw) ->
      assert expected == Gateway.filter( gw, &(&1.id <= 2) )
    end
  end

  defp compose_test_files seed do
    empty_json  = Poison.Encoder.encode([], [])
    filled_json = Poison.Encoder.encode(seed, [])
    File.write!(@filled_testfile, filled_json)
    File.write!(@empty_testfile, empty_json)
  end

end
