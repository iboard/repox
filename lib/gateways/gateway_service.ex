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

  @doc """
  Get the current gateway from the service
  #### Example:
      iex> gw = %ListGateway{}
      ...> {:ok, service} = GatewayService.start_service( gw )
      ...> GatewayService.gateway(service)
      %ListGateway{entries: []}
  """
  def gateway service do
    GenServer.call service, :gateway
  end

  @doc """
  Put a new entry to the gateway
  #### Example:
      iex> gw = %ListGateway{}
      ...> {:ok, service} = GatewayService.start_service( gw )
      ...> GatewayService.put(service, :new_entry)
      ...> GatewayService.gateway(service)
      %ListGateway{entries: [:new_entry]}
  """
  def put service, entry do
    GenServer.cast service, {:put, entry}
  end

  @doc """
  Filter by function
  #### Example:
      iex> gw = %ListGateway{ entries: [:a, :b, :c] }
      ...> {:ok, service} = GatewayService.start_service( gw )
      ...> GatewayService.where(service, &( &1 == :b ))
      [:b]
  """
  def where service, f do
    GenServer.call service, {:filter, f}
  end


  # Callbacks

  def handle_call :gateway, _from, service do
    {:reply, service.gateway, service}
  end

  def handle_call {:filter, f}, _from, service do
    found = Gateway.filter( service[:gateway], f )
    {:reply, found, service}
  end

  def handle_cast {:put, entry}, service do
    gw = Gateway.put(service[:gateway], entry)
    {:noreply, %{gateway: gw}}
  end

end
