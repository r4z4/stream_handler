defmodule StreamHandlerWeb.StreamLive.Index do
  use StreamHandlerWeb, :live_view

  alias StreamHandler.Streams
  alias StreamHandler.Streams.Stream

  @topic_3 "test_3"
  @topic_4 "test_4"

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
    StreamHandlerWeb.Endpoint.subscribe(@topic_3)
    StreamHandlerWeb.Endpoint.subscribe(@topic_4)
    {:ok,
      socket
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
    case params["id"] do
      "1" ->
        IO.puts "Service #1 Casted"
        # StreamHandlerWeb.Endpoint.broadcast_from(self(), @topic_4, "test_message", [])
        GenServer.cast :consumer_1, {:increment, "Hey #1"}
        GenServer.cast :consumer_1, {:add, %{name: "Pumpkin", price: 1}}
        GenServer.cast :consumer_2, {:add, %{name: "Cherry", price: 1}}
        GenServer.cast :consumer_3, {:add, %{name: "Blueberry", price: 1}}
        GenServer.cast :consumer_4, {:add, %{name: "Pecan", price: 1}}
      "2" ->
        IO.puts "Service #2 Casted"
        GenServer.cast :consumer_2, {:increment, "Hey #2"}
        GenServer.cast :consumer_1, {:add, %{name: "Pumpkin", price: 2}}
        GenServer.cast :consumer_2, {:add, %{name: "Cherry", price: 2}}
        GenServer.cast :consumer_3, {:add, %{name: "Blueberry", price: 2}}
        GenServer.cast :consumer_4, {:add, %{name: "Pecan", price: 2}}
      "3" ->
        IO.puts "Service #3 Casted"
        GenServer.cast :consumer_3, {:custom_event, "Custom Event String"}
        GenServer.cast :consumer_1, {:add, %{name: "Pumpkin", price: 3}}
        GenServer.cast :consumer_2, {:add, %{name: "Cherry", price: 3}}
        GenServer.cast :consumer_3, {:add, %{name: "Blueberry", price: 3}}
        GenServer.cast :consumer_4, {:add, %{name: "Pecan", price: 3}}
      "4" ->
        IO.puts "Service #4 Casted"
        IO.inspect(socket)
        Phoenix.PubSub.broadcast(
          StreamHandler.PubSub,
          @topic_4,
          %{topic: @topic_4, payload: %{status: :complete, text: "Service #4 has completed."}}
        )
        GenServer.cast :consumer_1, {:add, %{name: "Pumpkin", price: 4}}
        GenServer.cast :consumer_2, {:add, %{name: "Cherry", price: 4}}
        GenServer.cast :consumer_3, {:add, %{name: "Blueberry", price: 4}}
        GenServer.cast :consumer_4, {:add, %{name: "Pecan", price: 4}}
      _ ->
        IO.puts "No Service Casted"
    end

    {:noreply, socket}
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
end
