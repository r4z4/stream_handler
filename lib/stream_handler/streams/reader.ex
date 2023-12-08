defmodule StreamHandler.Streams.Reader do
  use GenServer

  @time_interval_ms 1000
  @call_interval_ms 7000
  @reader "reader"

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
  def init(state) do
    IO.inspect state, label: "init"
    {:ok, state}
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

  defp publish_str(str) do
    Phoenix.PubSub.broadcast(
      StreamHandler.PubSub,
      @reader,
      %{topic: @reader, payload: %{status: :complete, string: str}}
    )
  end

  @impl true
  def handle_info(:reader, state) do
    IO.puts "Handle Info GOING"
    files = Path.wildcard("./files/poems/*")
    file = Enum.random(files)
    {:ok, str} = File.read(file)
    new_str = String.replace(str, "\n", "<br />")
    html = Phoenix.HTML.raw("<div>#{new_str}</div>")
    publish_str(html)
    # File.stream!(file)
    #   |> Stream.map(&String.trim/1)
    #   |> Stream.with_index
    #   |> Stream.map(fn ({line, index}) -> publish({line, index}) end)
    #   |> Stream.run
    Process.send_after(self(), :reader, @time_interval_ms)
    # state = state ++ ["b"]
    {:noreply, state}
  end

end
