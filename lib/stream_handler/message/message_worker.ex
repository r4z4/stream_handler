defmodule StreamHandler.Message.MessageWorker do
  use GenServer

  def start_link({_file_path, worker_id}) do
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

  @impl true
  def init(state) do
    # _table = :ets.new(:user_scores, [:ordered_set, :protected, :named_table])
    IO.inspect state, label: "init"
    refs_map = %{transcribe_ref_a: nil, transcribe_ref_c: nil, transcriptions: [], ner_ref_a: nil, ner_ref_c: nil, ners: [], ner_preds: []}
    {:ok, refs_map}
  end

  @impl true
  def handle_cast({:ner_pipeline, path, server}, state) do
    IO.puts "Received Cast --> Path: #{path}"
    convert_file(path)
    file_name = path |> Path.basename() |> String.split(".") |> Enum.at(0)
    # old_ext = path |> Path.basename() |> String.split(".") |> Enum.at(1)
    # new_ext = "pcm"
    # new_path = String.replace(path, old_ext, new_ext)
    path = "./files/audio/conversions/" <> file_name <> ".pcm"
    binary = File.read!(path)
    # binary = <<12.2,14.4,15.3,2.2,3.3,4.5,14.4,15.3,2.2,3.3,4.5,14.4,15.3,2.2,3.3,4.5,14.4,15.3,2.2,3.3,4.5>>
    # We always pre-process audio on the client into a single channel
    audio = Nx.from_binary(binary, :f32)
    IO.inspect(audio, label: "audio")
    transcribe_task = Task.async(fn -> Nx.Serving.batched_run(StreamHandler.Serving, audio) end)
    IO.inspect(transcribe_task, label: "Transcribe Task")
    state =
      case server do
        :a -> Map.put(state, :transcribe_ref_a, transcribe_task.ref)
        :c -> Map.put(state, :transcribe_ref_c, transcribe_task.ref)
        _  -> IO.puts "No Value for Server Atom"
      end
    {:noreply, state}
  end

  @impl true
  def handle_cast({:ner, text, server}, state) do
    task = Task.async(fn -> Nx.Serving.batched_run(StreamHandler.TextClassificationServing, text) end)
    state =
      case server do
        :a -> Map.put(state, :ner_ref_a, task.ref)
        :c -> Map.put(state, :ner_ref_c, task.ref)
      end
    {:noreply, state}
  end

  # @impl true
  # def handle_info(:streamer, state) do
  #   IO.puts "Handle Streamer"
  #   # Just random data for now
  #   streamer_ref = Process.send_after(self(), :streamer, @call_interval_ms)
  #   state = Map.put(state, :streamer_ref, streamer_ref)
  #   {:noreply, state}
  # end

  def convert_file(path) do
    case String.contains? path, "." do
      true ->
        file_name = path |> Path.basename() |> String.split(".") |> Enum.at(0)
        # old_ext = path |> Path.basename() |> String.split(".") |> Enum.at(1)
        # new_path = String.replace(path, old_ext, "pcm")
        new_path = "./files/audio/conversions/" <> file_name <> ".pcm"
        # System.shell("ffmpeg -y -t 30 -i #{path} -f f32le -acodec pcm_f32le -ac 1 -ar 16000 -vn #{new_path}")
        System.shell("ffmpeg -y -i #{path} -f f32le -acodec pcm_f32le -ac 1 -ar 16000 -vn #{new_path}")
      false ->
        file_name = path |> Path.basename() |> String.split(".") |> Enum.at(0)
        # old_ext = path |> Path.basename() |> String.split(".") |> Enum.at(1)
        cur_path = "./files" <> path
        new_path = "./files/audio/conversions/" <> file_name <> ".pcm"
        # System.shell("ffmpeg -y -t 30 -i #{path} -f f32le -acodec pcm_f32le -ac 1 -ar 16000 -vn #{new_path}")
        System.shell("ffmpeg -y -i #{cur_path} -f f32le -acodec pcm_f32le -ac 1 -ar 16000 -vn #{new_path}")
    end
  end

  def handle_event("noop", %{}, socket) do
    # We need phx-change and phx-submit on the form for live uploads,
    # but we make predictions immediately using :progress, so we just
    # ignore this event
    {:noreply, socket}
  end

  # defp handle_progress(_name, _entry, socket), do: {:noreply, socket}

  # defp handle_progress(:audio, entry, socket) when entry.done? do
  #   IO.puts "Progress Audio"
  #   {:noreply, socket}
  # end

  # defp handle_progress(_, _, socket) do
  #   IO.puts "Progress"
  #   {:noreply, socket}
  # end

  def broadcast(topic, data) do
    Phoenix.PubSub.broadcast(
      StreamHandler.PubSub,
      topic,
      %{topic: topic, payload: %{status: :complete, data: data, text: "#{topic} - Service Completed"}}
    )
  end

  @impl true
  def handle_info({ref, result}, state) when ref in [state.transcribe_ref_a, state.transcribe_ref_c] do
    IO.inspect(ref, label: "Transcribe Ref")
    Process.demonitor(ref, [:flush])
    %{chunks: chunk_list} = result
    text = chunk_list |> Enum.map_join(& &1.text) |> String.trim()
    # %{chunks: [%{text: text, start_timestamp_seconds: _, end_timestamp_seconds: _}]} = result
    IO.inspect(text, label: "Bumblebee Text")
    broadcast("bb_text", text)
    File.write("./files/audio_output.txt", text)
    if ref == state.transcribe_ref_a do
      GenServer.cast :b, {:ner, text, :a}
    else
      GenServer.cast :b, {:ner, text, :c}
    end
    state = Map.put(state, :transcriptions, [text | state.transcriptions])
    {:noreply, state}
  end

  @impl true
  def handle_info({ref, result}, state) when ref in [state.ner_ref_a, state.ner_ref_c] do
    IO.inspect(ref, label: "Ner Ref")
    Process.demonitor(ref, [:flush])
    # Just a single record but it does return a list
    # %{entities: [%{label: label, start: _start, end: _end, phrase: phrase, score: score}]} = result
    %{entities: entity_list} = result
    case entity_list do
      [] -> IO.puts "No Entities"
      _  ->
        pred_list = Enum.map(entity_list, fn item -> %{label: item.label, entity: item.phrase, score: item.score} end)
        broadcast("bb_data", pred_list)
        for pred <- pred_list do
          IO.puts "It predicted a #{pred.label} of #{pred.entity}"
          # Broadcast message to send to ____
        end
    end

    state = Map.put(state, :ner_preds, [entity_list | state.ner_preds])
    {:noreply, state}
  end

end
