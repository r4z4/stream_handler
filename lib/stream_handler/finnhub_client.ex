defmodule StreamHandler.FinnhubClient do
  use WebSockex
  require Logger

  def start_link(_), do: WebSockex.start_link("wss://ws.finnhub.io?token=#{System.fetch_env!("FINNHUB_KEY")}", __MODULE__, nil)

  @impl true
  def handle_connect(_conn, state) do
    Logger.info("FinnHub...")
    send(self(), :subscribe)
    {:ok, state}
  end

  @impl true
  def handle_frame({:text, data}, state) do
    Logger.info("Received Finnhub: #{inspect(data)}")
    {:ok, state}
  end

  @impl true
  def handle_info(:subscribe, state) do
    subscribe =
      Jason.encode!(%{
        "type" => "subscribe",
        "symbol" => "AAPL"
      })
    {:reply, {:text, subscribe}, state}
  end

  # def handle_frame({type, msg}, state) do
  #   IO.puts("Received Message - Type: #{inspect(type)} -- Message: #{inspect(msg)}")
  #   {:ok, state}
  # end

  # def handle_cast({:send, {type, msg} = frame}, state) do
  #   IO.puts("Sending #{type} frame with payload: #{msg}")
  #   {:reply, frame, state}
  # end
end
