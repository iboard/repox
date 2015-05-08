defmodule GatewayService do
  @moduledoc """
  The GatewayService is an OTP GenServer which gets intitialized with
  a Gateway-implementation and is responsible to keep the state of the
  Gateway across the application.
  """

  use GenServer

  # Client API

  @doc """
  Start a Gateway service

  #### Example:
      iex> gw = %ListGateway{ entries: [:a, :b, :c] }
      ...> {:ok, service} = GatewayService.start_service( gw )
      ...> GatewayService.gateway(service)
      %ListGateway{entries: [:a, :b, :c]}
  """
  def start_service gateway  do
    GenServer.start_link(__MODULE__, %{gateway: gateway})
  end

  def gateway service do
    GenServer.call service, :gateway
  end


  # Callbacks

  def handle_call :gateway, _from, service do
    {:reply, service.gateway, service}
  end

end
