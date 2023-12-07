defmodule StreamHandler.Streams.Producer do
  use GenServer

  @time_interval_ms 1000
  @call_interval_ms 7000
  @activities "activities"
  @aq "aq"
  @emojis "emojis"
  @topic_3 "test_3"
  @topic_4 "test_4"
  @slugs "slugs"

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
  def handle_cast({:fetch_resource, sym}, state) do
    Process.send_after(self(), sym, @time_interval_ms)
    IO.puts(sym)
    {:noreply, state}
  end

  # #FIXME just have one cast, then disperse to handle_info
  # @impl true
  # def handle_cast({:custom_event, str}, state) do
  #   Process.send_after(self(), :custom_event, @time_interval_ms)
  #   IO.puts(str)
  #   {:noreply, state}
  # end

  # @impl true
  # def handle_cast({:slugs, str}, state) do
  #   Process.send_after(self(), :slugs, @time_interval_ms)
  #   IO.puts(str)
  #   {:noreply, state}
  # end

  # {:ok, contents} = File.read("haiku.txt")
  @impl true
  def init(state) do
    IO.inspect state, label: "init"
    {:ok, state}
  end

  defp get_slugs() do
    {:ok, resp} =
      Finch.build(:get, "https://ciprand.p3p.repl.co/api?len=20&count=10")
        |> Finch.request(StreamHandler.Finch)

    IO.inspect(resp, label: "Resp")
    {:ok, body} = Jason.decode(resp.body)
    body
  end

  defp get_activities() do
    {:ok, resp} =
      Finch.build(:get, "https://www.boredapi.com/api/activity/")
        |> Finch.request(StreamHandler.Finch)

    IO.inspect(resp, label: "Resp")
    {:ok, body} = Jason.decode(resp.body)
    body
  end

  defp get_aq() do
    {:ok, resp} =
      Finch.build(
        :get,
        "https://api.openaq.org/v1/locations?limit=100&page=1&offset=0&sort=desc&radius=1000&city=ARAPAHOE&order_by=lastUpdated&dump_raw=false",
        [{"Accept", "application/json"}, {"X-API-Key", System.fetch_env!("OPEN_AQ_KEY")}]
        )
        |> Finch.request(StreamHandler.Finch)

    IO.inspect(resp, label: "Resp")
    {:ok, body} = Jason.decode(resp.body)
    body
  end

  defp get_emojis() do
    {:ok, resp} =
      Finch.build(:get, "https://emojihub.yurace.pro/api/random")
        |> Finch.request(StreamHandler.Finch)

    IO.inspect(resp, label: "Resp")
    {:ok, body} = Jason.decode(resp.body)
    body
  end

  @impl true
  def handle_info(:custom_event, state) do
    IO.puts "Handle Info GOING"
    Process.send_after(self(), :custom_event, @time_interval_ms)
    Phoenix.PubSub.broadcast(
      StreamHandler.PubSub,
      @topic_3,
      %{topic: @topic_3, payload: %{status: :complete, data: state, text: "Custom Event has completed. #{state}"}}
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
      %{topic: @topic_4, payload: %{status: :complete, data: state, text: "Service #4 has completed. #{state}"}}
    )
    state = state ++ ["a"]
    {:noreply, state}
  end

  @impl true
  def handle_info(:slugs, state) do
    Process.send_after(self(), :slugs, @call_interval_ms)
    IO.puts(Enum.count(state))

    body = get_slugs()
    IO.inspect(body, label: "Body")
    # http://apilayer.net/api/live?access_key=#{System.fetch_env!("FOREX_API_KEY")}&currencies=EUR,GBP,CAD,PLN&source=USD&format=1
    Phoenix.PubSub.broadcast(
      StreamHandler.PubSub,
      @slugs,
      %{topic: @slugs, payload: %{status: :complete, data: state, text: "Slugs has completed. #{state}"}}
    )
    display =
      case Map.fetch(body, "Strings") do
        {:ok, strings} -> strings
        :error -> ["No List"]
      end
    # state = body["Strings"]
    state = display
    {:noreply, state}
  end

  @impl true
  def handle_info(:activities, state) do
    Process.send_after(self(), :activities, @call_interval_ms)
    IO.puts(Enum.count(state))

    activity =
      if Enum.count(state) > 0 do
        state.activity
      else
        "None Yet"
      end

    body = get_activities()
    IO.inspect(body, label: "Body")
    # http://apilayer.net/api/live?access_key=#{System.fetch_env!("FOREX_API_KEY")}&currencies=EUR,GBP,CAD,PLN&source=USD&format=1
    Phoenix.PubSub.broadcast(
      StreamHandler.PubSub,
      @activities,
      %{topic: @activities, payload: %{status: :complete, data: state, text: "Activities has completed. #{activity}"}}
    )
    activity =
      case Map.fetch(body, "activity") do
        {:ok, str} -> str
        :error -> "No Activity"
      end
    type =
      case Map.fetch(body, "type") do
        {:ok, str} -> str
        :error -> "No Type"
      end
    display = %{activity: activity, type: type}
    # state = body["Strings"]
    state = display
    {:noreply, state}
  end

  @impl true
  def handle_info(:aq, state) do
    Process.send_after(self(), :aq, @call_interval_ms)
    IO.puts(Enum.count(state))

    body = get_aq()
    IO.inspect(body, label: "Body")
    # http://apilayer.net/api/live?access_key=#{System.fetch_env!("FOREX_API_KEY")}&currencies=EUR,GBP,CAD,PLN&source=USD&format=1
    Phoenix.PubSub.broadcast(
      StreamHandler.PubSub,
      @aq,
      %{topic: @aq, payload: %{status: :complete, data: state, text: "aq has completed. #{state}"}}
    )

    {:noreply, state}
  end

  @impl true
  def handle_info(:emojis, state) do
    Process.send_after(self(), :emojis, @call_interval_ms)
    IO.puts(Enum.count(state))

    body = get_emojis()
    IO.inspect(body, label: "Body")
    # http://apilayer.net/api/live?access_key=#{System.fetch_env!("FOREX_API_KEY")}&currencies=EUR,GBP,CAD,PLN&source=USD&format=1
    Phoenix.PubSub.broadcast(
      StreamHandler.PubSub,
      @emojis,
      %{topic: @emojis, payload: %{status: :complete, data: state, text: "Emojis has completed"}}
    )
    name =
      case Map.fetch(body, "name") do
        {:ok, str} -> str
        :error -> "No Name"
      end
    category =
      case Map.fetch(body, "category") do
        {:ok, str} -> str
        :error -> "No Category"
      end
    group =
      case Map.fetch(body, "group") do
        {:ok, str} -> str
        :error -> "No Group"
      end
    unicode =
      case Map.fetch(body, "unicode") do
        {:ok, list} -> list
        :error -> "No Unicode"
      end
    # htmlCode =
    #   case Map.fetch(body, "htmlCode") do
    #     {:ok, list} -> list
    #     :error -> "No Type"
    #   end
    display = %{name: name, category: category, group: group, unicode: unicode}
    # state = body["Strings"]
    state = display
    {:noreply, state}

    {:noreply, state}
  end
end
