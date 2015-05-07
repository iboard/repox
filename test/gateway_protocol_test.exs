defmodule GatewayTest do
  use ExUnit.Case

  test "get all entries as a list" do
    gw = %ListGateway{}
    assert [] == Gateway.to_list(gw)
  end

  test "put something to the list" do
    gw = Gateway.put(%ListGateway{}, %{key: :value})
    assert [%{key: :value}] == Gateway.to_list(gw)
  end

  test "filter entries" do
    all = [ %{id: 1, value: "one"}, %{id: 2, value: "two"},
            %{id: 3, value: "three"} ]
    expected = Enum.take(all, 2)
    gw = %ListGateway{ entries: all }
    assert expected == Gateway.filter( gw, &(&1.id <= 2) )
  end
end
