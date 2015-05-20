defmodule BenchMacros do

  defmacro add_to_gateway(gw, count) do
    quote do
      Enum.each 1..unquote(count), fn(n) ->
        value = "This is entry number #{n}"
        Gateway.put(unquote(gw), %{id: n, value: value})
      end
    end
  end
end
