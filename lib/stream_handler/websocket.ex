defmodule StreamHandler.Websocket do
  use WebSockex
  require Logger

  def start_link(_), do: WebSockex.start_link("wss://ws.kraken.com", __MODULE__, nil)

  @impl true
  def handle_connect(_conn, state) do
    Logger.info("Connected...")
    send(self(), :subscribe)
    {:ok, state}
  end

  @impl true
  def handle_frame({:text, data}, state) do
    Logger.info("Received: #{inspect(data)}")
    new_message = Jason.decode!(data)
    IO.inspect(new_message, label: "NEW MESSAGE HEY")
    case new_message do
      %{"event" => "heartbeat"} -> IO.puts("Heartbeat")
      %{"connectionID" => conn, "event" => evemt, "status" => status, "version" => version} -> IO.puts("Connection")
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
      _ -> IO.puts("Ugh")
    end
  end

  @impl true
  def handle_info(:subscribe, state) do
    subscribe =
      Jason.encode!(%{
        "event" => "subscribe",
        "pair" => ["XBT/USDC"],
        "subscription" => %{"name" => "*"}
      })
    {:reply, {:text, subscribe}, state}
  end
end
