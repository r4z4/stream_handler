defmodule StreamHandler.Streams.Producer do
  use GenServer

  @time_interval_ms 1000
  @topic_3 "test_3"
  @topic_4 "test_4"

  def start_link([name, state]) do
    IO.inspect(state, label: "start_link")
    GenServer.start_link(__MODULE__, state, name: name)
  end

  @impl true
  def handle_cast({:add, product}, state) do
    IO.puts "Handle Cast of #{product.name} from #{product.price}"
    # state = state ++ [product]
    {:noreply, state}
  end

  # handle_cast handling the call from outside. Calls from the process (all subsequent) handled by handle_info
  @impl true
  def handle_cast({:increment, str}, state) do
    Process.send_after(self(), :increment, @time_interval_ms)
    IO.puts(str)
    {:noreply, state}
  end

  #FIXME just have one cast, then disperse to handle_info
  @impl true
  def handle_cast({:custom_event, str}, state) do
    Process.send_after(self(), :custom_event, @time_interval_ms)
    IO.puts(str)
    {:noreply, state}
  end

  # {:ok, contents} = File.read("haiku.txt")

  @impl true
  def init(state) do
    IO.inspect state, label: "init"
    {:ok, state}
  end

  @impl true
  def handle_info(:custom_event, state) do
    IO.puts "Handle Info GOING"
    Process.send_after(self(), :custom_event, @time_interval_ms)
    Phoenix.PubSub.broadcast(
      StreamHandler.PubSub,
      @topic_3,
      %{topic: @topic_3, payload: %{status: :complete, text: "Custom Event has completed. #{state}"}}
    )
    state = state ++ ["b"]
    {:noreply, state}
  end

  @impl true
  def handle_info(:increment, state) do
    Process.send_after(self(), :increment, @time_interval_ms)
    IO.puts(Enum.count(state))
    Phoenix.PubSub.broadcast(
      StreamHandler.PubSub,
      @topic_4,
      %{topic: @topic_4, payload: %{status: :complete, text: "Service #4 has completed. #{state}"}}
    )
    state = state ++ ["a"]
    {:noreply, state}
  end
end
