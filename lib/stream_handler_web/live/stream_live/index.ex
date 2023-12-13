defmodule StreamHandlerWeb.StreamLive.Index do
  use StreamHandlerWeb, :live_view

  alias StreamHandler.Streams

  embed_templates "dashboard_html/*"
  # alias StreamHandler.Streams.Stream

  @slugs "slugs"
  @emojis "emojis"
  @activities "activities"
  @aq "aq"
  @ets "ets"
  @topic_3 "test_3"
  @topic_4 "test_4"
  @reader "reader"
  @streamer "streamer"
  @images "images"

  # string() refers to Erlang strings. != Elixir strings.
  @spec get_class(map(), integer()) :: binary()
  def get_class(clicked_map, int) do
    if clicked_map[int] do
      "h-56 border-green border-4 p-1 flex"
    else
      "h-56 border-black border-4 p-1 flex"
    end
  end

  @impl true
  def handle_call(:ping, _from, state) do
    {:reply, {:pong, state[:id]}, state}
  end

  @impl true
  # def mount(_params, _session, socket) do
  #   {:ok, stream(socket, :stream_collection, Streams.list_stream())}
  # end

  def mount(_params, _session, socket) do
    IO.puts "Subscribing"
    StreamHandlerWeb.Endpoint.subscribe(@slugs)
    StreamHandlerWeb.Endpoint.subscribe(@emojis)
    StreamHandlerWeb.Endpoint.subscribe(@reader)
    StreamHandlerWeb.Endpoint.subscribe(@streamer)
    StreamHandlerWeb.Endpoint.subscribe(@images)
    StreamHandlerWeb.Endpoint.subscribe(@ets)
    StreamHandlerWeb.Endpoint.subscribe("websocket")

    StreamHandlerWeb.Endpoint.subscribe(@aq)
    StreamHandlerWeb.Endpoint.subscribe(@activities)
    StreamHandlerWeb.Endpoint.subscribe(@topic_3)
    StreamHandlerWeb.Endpoint.subscribe(@topic_4)
    init_map = %{1 => false, 2 => false, 3 => false, 4 => false, 5 => false, 6 => false, 7 => false, 8 => false, 9 => false, 10 => false, 11 => false, 12 => false, 13 => false, 14 => false, 15 => false, 16 => false, 17 => false, 18 => false}
    {:ok,
      socket
      |> assign(:clicked_map, init_map)
      |> assign(:slugs, nil)
      |> assign(:emojis, nil)
      |> assign(:reader, nil)
      |> assign(:images, nil)
      |> assign(:activities, nil)
      |> assign(:ets, nil)
      |> assign(:aq, nil)
      |> assign(:streamer_svg, nil)

      |> stream(:messages, [])
      |> stream(:spreads, [])
      # |> stream(:tickers, [])
      |> assign(:message, '')

      |> assign(:text, "Start")
      |> assign(:number, 0)
      |> assign(:text_3, "Number Three")
      |> assign(:number_3, 3)

      |> assign(:uploaded_files, [])
      |> allow_upload(:avatar, accept: ~w(.mp3 .m4a), max_entries: 2)
    }
  end

  # @impl true
  # def handle_params(params, _url, socket) do
  #   {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  # end

  # defp apply_action(socket, :edit, %{"id" => id}) do
  #   socket
  #   |> assign(:page_title, "Edit Stream")
  #   |> assign(:stream, Streams.get_stream!(id))
  # end

  # defp apply_action(socket, :new, _params) do
  #   socket
  #   |> assign(:page_title, "New Stream")
  #   |> assign(:stream, %Stream{})
  # end

  # defp apply_action(socket, :index, _params) do
  #   socket
  #   |> assign(:page_title, "Listing Stream")
  #   |> assign(:stream, nil)
  # end

  @impl true
  def handle_event("service_casted", params, socket) do
    # FIXME
    clicked_map = socket.assigns.clicked_map
    {int, _rem} = Integer.parse(params["id"])
    map_int =
      case int do
        x when x in 1..9 -> x
        x when x in 10..18 -> x - 9
        _ -> 0
      end
    IO.inspect(map_int, label: "MAP _______ INT")
    # Match on int, not map_int
    adjusted_map =
      case int do
        # Simulate ALL clicked. Map.replace return a [%{old}, %{new}]
        5   -> %{1 => true, 2 => true, 3 => true, 4 => true, 5 => true, 6 => true, 7 => true, 8 => true, 9 => true}
        14  -> %{1 => false, 2 => false, 3 => false, 4 => false, 5 => false, 6 => false, 7 => false, 8 => false, 9 => false}
        _   -> Map.put(clicked_map, map_int, !clicked_map[map_int])
      end
    IO.inspect(adjusted_map, label: "Adjusted ____________ Map")
    case params["id"] do
      # Num + 9 is the Key for Stopping Service (for now)
      "1" ->
        IO.puts "Slugs Casted"
        test_file = "./files/audio/one_min_five.m4a"
        # StreamHandlerWeb.Endpoint.broadcast_from(self(), @topic_4, "test_message", [])
        # GenServer.cast :consumer_1, {:fetch_resource, :slugs}
        GenServer.cast :a, {:ner_pipeline, test_file}
      "10" ->
        IO.puts "Service #1 (Slugs) Stopped"
        # StreamHandlerWeb.Endpoint.broadcast_from(self(), @topic_4, "test_message", [])
        GenServer.cast :consumer_1, {:stop_resource, :slugs}

      "2" ->
        IO.puts "Emojis Casted"
        GenServer.cast :consumer_2, {:fetch_resource, :emojis}
      "11" ->
        IO.puts "Emojis Stopped"
        GenServer.cast :consumer_2, {:stop_resource, :emojis}

      "3" ->
        IO.puts "Activities Casted"
        GenServer.cast :consumer_4, {:fetch_resource, :activities}
      "12" ->
        IO.puts "Activities Stopped"
        GenServer.cast :consumer_4, {:stop_resource, :activities}

      "4" ->
        IO.puts "WebSockex Casted"
        # Use start and not start_link to avoid being alerted when we close conn
        StreamHandler.Servers.Websocket.start(:hey)
      "13" ->
        IO.puts "WebSockex Stopped"
        WebSockex.cast :kraken, {:stop_resource, :ws}

      "5" ->
        IO.puts "Casting All Services"
        # GenServers
        GenServer.cast :reader,     {:fetch_resource, :reader}
        GenServer.cast :reader,     {:fetch_resource, :images}
        GenServer.cast :reader,     {:fetch_resource, :ets}
        GenServer.cast :streamer,   {:fetch_resource, :streamer}
        GenServer.cast :consumer_2, {:fetch_resource, :emojis}
        GenServer.cast :consumer_1, {:fetch_resource, :slugs}
        GenServer.cast :consumer_4, {:fetch_resource, :activities}
        # Websockex
        StreamHandler.Servers.Websocket.start(:hey)
      "14" ->
        IO.puts "Stopping All Services"
        # GenServers
        GenServer.cast :reader,     {:stop_resource, :reader}
        GenServer.cast :reader,     {:stop_resource, :images}
        GenServer.cast :reader,     {:stop_resource, :ets}
        GenServer.cast :streamer,   {:stop_resource, :streamer}
        GenServer.cast :consumer_2, {:stop_resource, :emojis}
        GenServer.cast :consumer_1, {:stop_resource, :slugs}
        GenServer.cast :consumer_4, {:stop_resource, :activities}
        # Websockex
        WebSockex.cast :kraken, {:stop_resource, :ws}

      "6" ->
        IO.puts "Leaderboard Casted"
        GenServer.cast :reader, {:fetch_resource, :ets}
      "15" ->
        IO.puts "Leaderboard Stopped"
        GenServer.cast :reader, {:stop_resource, :ets}

      "7" ->
        IO.puts "Streamer Casted"
        GenServer.cast :streamer, {:fetch_resource, :streamer}
      "16" ->
        IO.puts "Streamer Stopped"
        GenServer.cast :streamer, {:stop_resource, :streamer}

      "8" ->
        IO.puts "Reader Casted"
        GenServer.cast :reader, {:fetch_resource, :reader}
      "17" ->
        IO.puts "Stopping Reader"
        GenServer.cast :reader, {:stop_resource, :reader}

      "9" ->
        IO.puts "Images Casted"
        GenServer.cast :reader, {:fetch_resource, :images}
      "18" ->
        IO.puts "Images Stopped"
        GenServer.cast :reader, {:stop_resource, :images}

      _ ->
        IO.puts "No Service Casted"
    end
    {:noreply,
      socket
      |> assign(clicked_map: adjusted_map)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    stream = Streams.get_stream!(id)
    {:ok, _} = Streams.delete_stream(stream)

    {:noreply, stream_delete(socket, :stream_collection, stream)}
  end

  @impl true
  def handle_info({StreamHandlerWeb.StreamLive.FormComponent, {:saved, stream}}, socket) do
    {:noreply, stream_insert(socket, :stream_collection, stream)}
  end

  @impl true
  def handle_info(%{topic: @topic_4, payload: msg}, socket) do
    IO.inspect(socket)
    IO.puts "HANDLE BROADCAST FOR #{msg[:status]}"
    {:noreply,
      socket
      |> assign(:text, msg[:text])
      |> assign(:number, 5)
    }
  end

  @impl true
  def handle_info(%{topic: @topic_3, payload: msg}, socket) do
    IO.inspect(socket)
    IO.puts "HANDLE BROADCAST 3 FOR #{msg[:text]}"
    {:noreply,
      socket
      |> assign(:text_3, msg[:text])
      |> assign(:number_3, 30)
    }
  end

  @impl true
  def handle_info(%{topic: @slugs, payload: msg}, socket) do
    IO.inspect(socket)
    IO.puts "Handle Broadcast for Slugs"
    {:noreply,
      socket
      |> assign(:slugs, msg[:data])
    }
  end

  @impl true
  def handle_info(%{topic: @emojis, payload: msg}, socket) do
    IO.inspect(socket)
    IO.puts "Handle Broadcast for Emojis"
    {:noreply,
      socket
      |> assign(:emojis, msg[:data])
    }
  end

  @impl true
  def handle_info(%{topic: @activities, payload: msg}, socket) do
    IO.inspect(socket)
    IO.inspect(msg, label: "Msg")
    IO.puts "Handle Broadcast for Activities"
    {:noreply,
      socket
      |> assign(:activities, msg[:data])
      # Might want to use :status at some point?
      # |> assign(:activities, msg)
    }
  end

  @impl true
  def handle_info(%{topic: @aq, payload: msg}, socket) do
    IO.inspect(socket)
    IO.inspect(msg, label: "Msg")
    IO.puts "HANDLE Broadcast Aq FOR #{msg[:text]}"
    {:noreply,
      socket
      |> assign(:aq, msg)
    }
  end

  @impl true
  def handle_info(%{topic: @ets, payload: msg}, socket) do
    IO.inspect(socket)
    IO.inspect(msg, label: "Msg")
    IO.puts "Handle Broadcast ETS For #{msg[:text]}"
    {:noreply,
      socket
      |> assign(:ets, msg)
    }
  end

  @impl true
  def handle_info(%{topic: @reader, payload: msg}, socket) do
    IO.inspect(socket)
    IO.inspect(msg, label: "Msg")
    IO.puts "Handle Broadcast for Reader"
    {:noreply,
      socket
      |> assign(:reader, msg)
    }
  end

  @impl true
  def handle_info(%{topic: @streamer, payload: msg}, socket) do
    IO.inspect(socket)
    IO.inspect(msg, label: "Msg")
    IO.puts "Handle Broadcast for Streamer"
    {:noreply,
      socket
      |> assign(:streamer_svg, msg[:svg])
    }
  end

  @impl true
  def handle_info(%{topic: @images, payload: msg}, socket) do
    IO.inspect(socket)
    IO.inspect(msg, label: "Msg")
    IO.puts "Handle Broadcast @images"
    {:noreply,
      socket
      |> assign(:images, msg)
    }
  end

  @impl true
  def handle_info(%{event: "new_message", payload: new_message}, socket) do
    # updated_messages = socket.assigns[:messages] ++ [new_message]
    IO.inspect(socket, label: "Socket")
    case new_message do
        "{\"event\":\"heartbeat\"}" ->
            IO.puts "Kraken Heartbeat"
            {:noreply, socket}
        %{"event" => "heartbeat"} ->
            IO.puts "Kraken Heartbeat Map"
            {:noreply, socket}
        _ ->
            new_message = %{id: List.first(new_message), data: Kernel.elem(List.pop_at(new_message, 1), 0)}
            IO.inspect(new_message, label: "The New Message!!")
            {:noreply,
                socket
                |> stream_insert(:messages, new_message)}
    end
  end

  @impl true
  def handle_info(%{event: "new_spread", payload: new_message}, socket) do
    IO.inspect(new_message, label: "New Spread MEssage")
    new_message = %{id: List.first(new_message), data: Kernel.elem(List.pop_at(new_message, 1), 0)}
    {:noreply,
        socket
        |> stream_insert(:spreads, new_message)}
  end

  @impl true
  def handle_info(%{event: "new_ticker", payload: new_message}, socket) do
    IO.inspect(new_message, label: "New Ticker MEssage")
    new_message = %{id: List.first(new_message), data: Kernel.elem(List.pop_at(new_message, 1), 0)}
    {:noreply,
        socket
        |> stream_insert(:tickers, new_message)}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :avatar, ref)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", _params, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :avatar, fn %{path: path}, _entry ->
        IO.inspect(Path.extname(path), label: "Path")
        # Actually might not even need this
        # ext =
        #   case ExMarcel.MimeType.for {:path, path} do
        #     "video/mp4" -> ".m4a"
        #     "audio/mp3" -> ".mp3"
        #     _           -> ""
        #   end
        # dest = Path.join([:code.priv_dir(:stream_handler), "static", "uploads", Path.basename(path)])
        # FIXME use ExMarcel to detect MIME type
        dest = Path.join(["./files/uploads", Path.basename(path)])
        File.cp!(path, dest)
        {:ok, ~p"/uploads/#{Path.basename(dest)}"}
      end)

    # Files now ready to be transcribed.
    GenServer.cast :a, {:ner_pipeline, Enum.at(uploaded_files, 0)}

    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"

end
