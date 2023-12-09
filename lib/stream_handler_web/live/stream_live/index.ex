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
  @images "images"

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

      |> stream(:messages, [])
      |> stream(:spreads, [])
      |> assign(:message, '')

      |> assign(:text, "Start")
      |> assign(:number, 0)
      |> assign(:text_3, "Number Three")
      |> assign(:number_3, 3)
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
    adjusted_map = Map.put(clicked_map, map_int, !clicked_map[map_int])
    case params["id"] do
      # Num + 9 is the Key for Stopping Service (for now)
      "1" ->
        IO.puts "Slugs Casted"
        # StreamHandlerWeb.Endpoint.broadcast_from(self(), @topic_4, "test_message", [])
        GenServer.cast :consumer_1, {:fetch_resource, :slugs}
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
        IO.puts "Service #3 Casted"
        StreamHandler.Websocket.start_link(:hey)
        # GenServer.cast :consumer_3, {:fetch_resource, :custom_event}
        # GenServer.cast :consumer_1, {:add, %{name: "Pumpkin", price: 3}}
        # GenServer.cast :consumer_2, {:add, %{name: "Cherry", price: 3}}
        # GenServer.cast :consumer_3, {:add, %{name: "Blueberry", price: 3}}
        # GenServer.cast :consumer_4, {:add, %{name: "Pecan", price: 3}}
      "13" ->
        IO.puts "Service #3 Casted"
        WebSockex.cast :kraken, {:stop_resource, :ws}
      "5" ->
        IO.puts "Casting All Services"
        GenServer.cast :reader,     {:fetch_resource, :reader}
        GenServer.cast :reader,     {:fetch_resource, :images}
        GenServer.cast :consumer_2, {:fetch_resource, :emojis}
        GenServer.cast :consumer_1, {:fetch_resource, :slugs}
        GenServer.cast :reader,     {:fetch_resource, :ets}
        GenServer.cast :consumer_4, {:fetch_resource, :activities}
      "14" ->
        IO.puts "Casting All Services"
        GenServer.cast :reader,     {:stop_resource, :reader}
        GenServer.cast :reader,     {:stop_resource, :images}
        GenServer.cast :consumer_2, {:stop_resource, :emojis}
        GenServer.cast :consumer_1, {:stop_resource, :slugs}
        GenServer.cast :reader,     {:stop_resource, :ets}
        GenServer.cast :consumer_4, {:stop_resource, :activities}
      "6" ->
        IO.puts "Leaderboard Casted"
        GenServer.cast :reader, {:fetch_resource, :ets}
      "15" ->
        IO.puts "Leaderboard Stopped"
        GenServer.cast :reader, {:stop_resource, :ets}
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
    IO.inspect(new_message, label: "New Message")
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

  defp build_button_assigns do

  end
end
