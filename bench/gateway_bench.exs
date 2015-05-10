defmodule GatewayBench do
  use Benchfella

  # Lists
  bench "do .to_list on an empty  ListGateway", [list: gen_list(:empty)] do
    gw = %ListGateway{entries: list}
    Gateway.to_list(gw)
  end

  bench "do .to_list on a ListGateway with some entries", [list: gen_list(:default)] do
    gw = %ListGateway{entries: list}
    Gateway.to_list(gw)
  end

  bench "Put items to GatewayService with ListGateway", [list: gen_list(:default)] do
    {:ok, service} = GatewayService.start_service( %ListGateway{} )
    Enum.each(list, fn(e) ->
      GatewayService.put service, e
    end)
  end

  bench "Put items to GatewayService with FileGateway", [list: gen_list(:default), file: create_file] do
    {:ok, service} = GatewayService.start_service( %ListGateway{} )
    Enum.each(list, fn(e) ->
      GatewayService.put service, e
    end)
  end

  bench "Read 1000 entries from a ListGateway", [gw: gen_list_gw(1000)] do
    Gateway.to_list(gw)
  end

  bench "Read 1000 entries from a FileGateway", [gw: gen_file_gw(1000)] do
    Gateway.to_list(gw)
  end

  bench "Find within 1000 entries from ListGateway", [gw: gen_list_gw(1000)] do
    Gateway.filter(gw, &(&1.id == 999))
  end

  bench "Find within 1000 entries from FileGateway", [gw: gen_file_gw(1000)] do
    Gateway.filter(gw, &(&1.id == 999))
  end

  bench "Find within 1000 entries from ListGatewayService", [gw: gen_list_service(1000)] do
    GatewayService.where(gw, &(&1.id == 999))
  end

  bench "Find within 1000 entries from FileGatewayService", [gw: gen_file_service(1000)] do
    GatewayService.where(gw, &(&1.id == 999))
  end

  defp gen_list_service count do
    {:ok, service} = GatewayService.start_service(gen_list_gw(count))
    service
  end

  defp gen_file_service count do
    {:ok, service} = GatewayService.start_service(gen_file_gw(count))
    service
  end

  defp gen_list_gw(count) when count >= 1 do
    list = Enum.map( 1..count, fn(n) ->
      value = "Entry #{n}"
      %{ id: count, name: value }
    end)
    %ListGateway{entries: list}
  end

  defp gen_file_gw(count) when count >=1 do
    list = Enum.map(1..count, fn(n) ->
      %{ id: n, value: Integer.to_string(n) }
    end)
    json = Poison.Encoder.encode( list, [] )
    File.write!("/tmp/#{__MODULE__}.1000", json)
    %FileGateway{path: "/tmp/#{__MODULE__}.1000"}
  end

  defp gen_list :empty do
    []
  end

  defp gen_list :default do
    [
      %{ id: 1, value: "Hello" },
      %{ id: 2, value: "World" },
      %{ id: 3, value: ['what', 'ever', 'you', 'want'] }
    ]
  end

  defp create_file do
    Poison.Encoder.encode([], [])
      |> File.write!( "/tmp/#{__MODULE__}.bench")
  end
end
