defmodule StreamHandler.Streams.Reader do
  use GenServer

  @time_interval_ms 2000
  @call_interval_ms 7000
  @reader "reader"
  @images "images"

  def start_link([name, state]) do
    IO.inspect(state, label: "start_link")
    GenServer.start_link(__MODULE__, state, name: name)
  end

  # handle_cast handling the call from outside. Calls from the process (all subsequent) handled by handle_info
  @impl true
  def handle_cast({:fetch_resource, sym}, state) do
    Process.send_after(self(), sym, @time_interval_ms)
    IO.puts(sym)
    {:noreply, state}
  end

  @impl true
  def handle_cast({:stop_resource, sym}, state) do
    IO.inspect(state, label: "State")
    case sym do
      :images -> Process.cancel_timer(state.images_ref)
      :reader -> Process.cancel_timer(state.reader_ref)
      _ -> Process.cancel_timer(state.reader_ref)
    end
    # Process.cancel_timer(self(), sym, @time_interval_ms)
    IO.puts(sym)
    {:noreply, state}
  end

  @impl true
  def init(state) do
    IO.inspect state, label: "init"
    refs_map = %{reader_ref: nil, images_ref: nil}
    {:ok, refs_map}
  end

  # defp read_line() do
  #   {:ok, resp} =
  #     Finch.build(:get, "https://emojihub.yurace.pro/api/random")
  #       |> Finch.request(StreamHandler.Finch)

  #   IO.inspect(resp, label: "Resp")
  #   {:ok, body} = Jason.decode(resp.body)
  #   body
  # end

  defp publish({line, index}) do
    Phoenix.PubSub.broadcast(
      StreamHandler.PubSub,
      @reader,
      %{topic: @reader, payload: %{status: :complete, string: "#{index + 1} #{line}"}}
    )
  end

  defp publish_str(at, str) do
    Phoenix.PubSub.broadcast(
      StreamHandler.PubSub,
      at,
      %{topic: at, payload: %{status: :complete, string: str}}
    )
  end

  @impl true
  def handle_info(:reader, state) do
    IO.puts "Handle Reader"
    files = Path.wildcard("./files/poems/*")
    file = Enum.random(files)
    {:ok, str} = File.read(file)
    new_str = String.replace(str, "\n", "<br />")
    html = Phoenix.HTML.raw("<div>#{new_str}</div>")
    publish_str(@reader, html)
    # File.stream!(file)
    #   |> Stream.map(&String.trim/1)
    #   |> Stream.with_index
    #   |> Stream.map(fn ({line, index}) -> publish({line, index}) end)
    #   |> Stream.run
    reader_ref = Process.send_after(self(), :reader, @call_interval_ms)
    # state = state ++ ["b"]
    state = Map.put(state, :reader_ref, reader_ref)
    {:noreply, state}
  end

  @impl true
  def handle_info(:images, state) do
    IO.puts "Handle Images"
    files = Path.wildcard("./priv/static/images/*")
    file = Enum.random(files)
    new_path = String.replace(file, "priv/static", "")
    publish_str(@images, new_path)
    images_ref = Process.send_after(self(), :images, @time_interval_ms)
    # state = state ++ ["b"]
    state = Map.put(state, :images_ref, images_ref)
    {:noreply, state}
  end

end
