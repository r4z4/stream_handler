defmodule StreamHandler.Streams.Reader do
  use GenServer
  alias StreamHandler.Repo
  alias StreamHandler.Streams.UserScore

  @time_interval_ms 2000
  @call_interval_ms 7000
  @reader "reader"
  @images "images"
  @ets "ets"

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
      :ets -> Process.cancel_timer(state.ets_ref)
      _ -> Process.cancel_timer(state.reader_ref)
    end
    # Process.cancel_timer(self(), sym, @time_interval_ms)
    IO.puts(sym)
    {:noreply, state}
  end

  @impl true
  def init(state) do
    _table = :ets.new(:user_scores, [:ordered_set, :protected, :named_table])
    initialize_score_ets_from_db()
    IO.inspect state, label: "init"
    refs_map = %{reader_ref: nil, images_ref: nil, ets_ref: nil}
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

  def initialize_score_ets_from_db do
    user_scores = Repo.all(UserScore)
    Enum.map(user_scores, fn score ->
      IO.inspect(score, label: "Score")
      :ets.insert(:user_scores, {score.username, score.score, score.joined})
    end)
  end

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

  def shuffle_user_scores(user_scores) do
    :ets.delete(:user_scores)
    :ets.new(:user_scores, [:ordered_set, :protected, :named_table])
    Enum.map(user_scores, fn score ->
      :ets.insert(:user_scores, {score.username, :rand.uniform(150), score.joined})
    end)
  end

  def get_user_scores do
    # ms = :ets.fun2ms fn {score, username, joined} -> {score, username, joined} end
    tuples = :ets.tab2list(:user_scores)
    user_scores =
      Enum.map(tuples, fn {username, score, joined} ->
        %UserScore{username: username, score: score, joined: joined}
      end)
    # scores = :ets.match_object(:user_scores, {'$0', '$1', '$2'})
    # IO.inspect(scores, label: scores)
    user_scores
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
    files = Path.wildcard("./priv/static/images/ava/*")
    file = Enum.random(files)
    new_path = String.replace(file, "priv/static", "")
    publish_str(@images, new_path)
    images_ref = Process.send_after(self(), :images, @time_interval_ms)
    # state = state ++ ["b"]
    state = Map.put(state, :images_ref, images_ref)
    {:noreply, state}
  end

  @impl true
  def handle_info(:ets, state) do
    IO.puts "Handle ETS"
    scores = get_user_scores()
    shuffle_user_scores(scores)
    # struct_list =
    #   Enum.map(scores, fn score ->
    #     _s = struct!(UserScore, score)
    #   end)
    # IO.inspect(struct_list, label: "Struct List")
    sorted = Enum.sort_by(scores, &(&1.score), :desc)
    publish_str(@ets, sorted)
    ets_ref = Process.send_after(self(), :ets, @time_interval_ms)
    # state = state ++ ["b"]
    state = Map.put(state, :ets_ref, ets_ref)
    {:noreply, state}
  end

end
