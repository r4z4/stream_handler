defmodule StreamHandler.Servers.Websocket do
  use WebSockex
  require Logger

  @ws "ws"
  def start_link(_), do: WebSockex.start_link("wss://ws.kraken.com", __MODULE__, nil, name: :kraken)

  def start(_), do: WebSockex.start("wss://ws.kraken.com", __MODULE__, nil, name: :kraken)

  @impl true
  def handle_connect(_conn, state) do
    Logger.info("Connected...")
    send(self(), :subscribe)
    {:ok, state}
  end

  # @impl true
  # def handle_cast({:fetch_resource, sym}, state) do
  #   Process.send_after(self(), sym, @time_interval_ms)
  #   IO.puts(sym)
  #   {:noreply, state}
  # end

  @impl true
  def handle_cast({:stop_resource, sym}, state) do
    IO.puts "Kraken Stopping"
    IO.inspect(state, label: "State")
    # case sym do
    #   :ws -> Process.cancel_timer(state.images_ref)
    #   _ -> Process.cancel_timer(state.reader_ref)
    # end
    send(self(), :close_socket)
    # Process.cancel_timer(self(), sym, @time_interval_ms)
    IO.puts(sym)
    {:noreply, state}
  end

  @impl true
  def handle_frame({:text, data}, state) do
    Logger.info("Received: #{inspect(data)}")
    new_message = Jason.decode!(data)
    IO.inspect(new_message, label: "NEW MESSAGE HEY")
    case new_message do
      %{"event" => "heartbeat"} -> IO.puts("Heartbeat")
      %{"connectionID" => conn, "event" => event, "status" => status, "version" => version} -> IO.puts("Connection")
      new_message when map_size(new_message) == 6 -> IO.puts("Other 6 Connection")
      _ -> broadcast_it(new_message)
    end
    {:ok, state}
  end

  def broadcast_it(msg) do
    IO.inspect(msg, label: "Broadcast MSG")
    case Kernel.elem(List.pop_at(msg, 2), 0) do
      "spread" -> StreamHandlerWeb.Endpoint.broadcast!("websocket", "new_spread", msg)
      "book-10" -> StreamHandlerWeb.Endpoint.broadcast!("websocket", "new_message", msg)
      # Just subscribing to the ticker endpoint
      # "ticker" -> StreamHandlerWeb.Endpoint.broadcast!("websocket", "new_ticker", msg)
      _ -> IO.puts("Ugh")
    end
  end

  @impl true
  def handle_info(:subscribe, state) do
    subscribe =
      Jason.encode!(%{
        "event" => "subscribe",
        "pair" => ["XBT/USD"],
        "subscription" => %{"name" => "*"}
      })
    {:reply, {:text, subscribe}, state}
  end

  def handle_info(:close_socket, state) do
    # :timer.cancel(t_ref)
    {:close, state}
  end
end
