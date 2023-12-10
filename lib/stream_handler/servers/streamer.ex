defmodule StreamHandler.Servers.Streamer do
  use GenServer
  alias Contex.{PointPlot, Plot, Dataset}
  alias StreamHandler.Repo
  alias StreamHandler.Streams.UserScore

  @time_interval_ms 2000
  @call_interval_ms 6000
  @max 3
  @max_2 6
  @streamer "streamer"

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
    # _table = :ets.new(:user_scores, [:ordered_set, :protected, :named_table])
    IO.inspect state, label: "init"
    refs_map = %{streamer_ref: nil}
    {:ok, refs_map}
  end

  def generate_data do
     # Get 10 lists of random # of tuples
    list_of_lists =
      StreamData.list_of(
        StreamData.tuple({
          StreamData.float(min: 0, max: @max),
          StreamData.float(min: 0, max: @max_2)}
        )
      ) |> Enum.take(10)
    combined_list = Enum.reduce(list_of_lists, fn x, acc -> x ++ acc end)
    combined_list
  end

  def generate_svg do
    data = generate_data()
    ds = Dataset.new(data, ["x", "y"])
    point_plot = PointPlot.new(ds)
    plot = Plot.new(600, 400, point_plot)
      |> Plot.plot_options(%{legend_setting: :legend_right})
      |> Plot.titles("Stream Data Plot", "Property Testing & Data Streaming")

    Plot.to_svg(plot)
  end

  defp publish(svg) do
    Phoenix.PubSub.broadcast(
      StreamHandler.PubSub,
      @streamer,
      %{topic: @streamer, payload: %{status: :complete, svg: svg}}
    )
  end

  @impl true
  def handle_info(:streamer, state) do
    IO.puts "Handle Streamer"
    # Just random data for now
    svg = generate_svg()
    publish(svg)
    streamer_ref = Process.send_after(self(), :streamer, @call_interval_ms)
    state = Map.put(state, :streamer_ref, streamer_ref)
    {:noreply, state}
  end


end
