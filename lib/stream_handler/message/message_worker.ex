defmodule StreamHandler.Message.MessageWorker do
  use GenServer
  alias StreamHandler.Message.Membrane

  def start_link({file_path, worker_id}) do
    worker_goal = get_worker_goal(worker_id)
    IO.puts "Starting Message Worker for ID: #{worker_id}. #{worker_goal}"
    state = []
    GenServer.start_link(__MODULE__, state, name: worker_id)
  end

  @spec get_worker_goal(atom()) :: binary()
  def get_worker_goal(worker_id) do
    case worker_id do
      :a -> "I'm going to work on our company's audio messages"
      :b -> "I'm going to work on our company's video messages"
      :c -> "I'm going to work on our company's text messages"
      :d -> "I'm going to work on our company's email messages"
      :e -> "I'm going to work on our company's _other_ messages"
      _  -> "Unassigned"
    end
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
    refs_map = %{transcribe_ref: nil, transcription: nil, ner_ref: nil, ner: nil, ner_pred: nil}
    {:ok, refs_map}
  end

  @impl true
  def handle_info(:streamer, state) do
    IO.puts "Handle Streamer"
    # Just random data for now
    streamer_ref = Process.send_after(self(), :streamer, @call_interval_ms)
    state = Map.put(state, :streamer_ref, streamer_ref)
    {:noreply, state}
  end

  def convert_file(path) do
    file_name = path |> Path.basename() |> String.split(".") |> Enum.at(0)
    old_ext = path |> Path.basename() |> String.split(".") |> Enum.at(1)
    new_path = String.replace(path, old_ext, "pcm")
    # System.shell("ffmpeg -y -t 30 -i #{path} -f f32le -acodec pcm_f32le -ac 1 -ar 16000 -vn #{new_path}")
    System.shell("ffmpeg -y -i #{path} -f f32le -acodec pcm_f32le -ac 1 -ar 16000 -vn #{new_path}")
  end

  @impl true
  def handle_cast({:ner_pipeline, path}, state) do
    IO.puts "Received Cast --> Path: #{path}"
    convert_file(path)
    old_ext = path |> Path.basename() |> String.split(".") |> Enum.at(1)
    new_ext = "pcm"
    new_path = String.replace(path, old_ext, new_ext)
    binary = File.read!(new_path)
    # binary = <<12.2,14.4,15.3,2.2,3.3,4.5,14.4,15.3,2.2,3.3,4.5,14.4,15.3,2.2,3.3,4.5,14.4,15.3,2.2,3.3,4.5>>
    # We always pre-process audio on the client into a single channel
    audio = Nx.from_binary(binary, :f32)
    IO.inspect(audio, label: "audio")
    transcribe_task = Task.async(fn -> Nx.Serving.batched_run(StreamHandler.Serving, audio) end)
    IO.inspect(transcribe_task, label: "Transcribe Task")
    state = Map.put(state, :transcribe_ref, transcribe_task)
    {:noreply, state}
  end

  defp handle_progress(_name, _entry, socket), do: {:noreply, socket}

  def handle_event("noop", %{}, socket) do
    # We need phx-change and phx-submit on the form for live uploads,
    # but we make predictions immediately using :progress, so we just
    # ignore this event
    {:noreply, socket}
  end

  def handle_cast({:ner, text}, state) do
    task = Task.async(fn -> Nx.Serving.batched_run(StreamHandler.TextClassificationServing, text) end)
    state = Map.put(state, :ner_ref, task)
    {:noreply, state}
  end

  defp handle_progress(:audio, entry, socket) when entry.done? do
    IO.puts "Progress Audio"
    {:noreply, socket}
  end

  defp handle_progress(_, _, socket) do
    IO.puts "Progress"
    {:noreply, socket}
  end

  @impl true
  def handle_info({ref, result}, state) when state.transcribe_ref.ref == ref do
    IO.inspect(ref, label: "Transcribe Ref")
    Process.demonitor(ref, [:flush])
    %{chunks: [%{text: text, start_timestamp_seconds: _, end_timestamp_seconds: _}]} = result
    IO.inspect(text, label: "Bumblebee Text")
    File.write("./files/audio_output.txt", text)
    GenServer.cast :b, {:ner, text}
    state = Map.put(state, :transcription, text)
    {:noreply, state}
  end

  @impl true
  def handle_info({ref, result}, state) when state.ner_ref.ref == ref do
    IO.inspect(ref, label: "Ner Ref")
    Process.demonitor(ref, [:flush])
    # Just a single record but it does return a list
    # %{entities: [%{label: label, start: _start, end: _end, phrase: phrase, score: score}]} = result
    %{entities: entity_list} = result
    for %{label: label, start: _start, end: _end, phrase: phrase, score: score} <- entity_list do
      prediction = %{label: label, entity: phrase, score: score}
      IO.puts "It predicted a #{prediction.label} of #{prediction.entity}"
    end
    state = Map.put(state, :ner_pred, entity_list)
    {:noreply, state}
  end

end
