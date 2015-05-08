defmodule GatewayServiceTest do
  use ExUnit.Case
  doctest GatewayService

  setup do
    entries = [
      %{id: 1, value: "one"},
      %{id: 2, value: "two"},
      %{id: 3, value: "three"}
    ]
    {:ok, service} = GatewayService.start_service( %ListGateway{ entries: entries } )
    {:ok, entries: entries, service: service}
  end


  test "initialize a gateway service", context do
    gw = GatewayService.gateway(context[:service])
    assert context[:entries] == Gateway.to_list(gw)
  end

  test "add an entry to the gateway, using the service, and retreive it", context do
    GatewayService.put(context[:service], "four")
    assert ["four"] == GatewayService.where( context[:service], &( &1 == "four" ) )
  end

end
