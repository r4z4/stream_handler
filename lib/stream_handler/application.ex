defmodule StreamHandler.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do

    {:ok, model_info} = Bumblebee.load_model({:hf, "openai/whisper-tiny"})
    {:ok, featurizer} = Bumblebee.load_featurizer({:hf, "openai/whisper-tiny"})
    {:ok, tokenizer} = Bumblebee.load_tokenizer({:hf, "openai/whisper-tiny"})
    {:ok, generation_config} = Bumblebee.load_generation_config({:hf, "openai/whisper-tiny"})

    serving =
      Bumblebee.Audio.speech_to_text_whisper(model_info, featurizer, tokenizer, generation_config,
        # max_new_tokens: 100,
        defn_options: [compiler: EXLA]
      )
    # # Listen for our stream heavy app, the repo module, and any type of queries
    # :ok = :telemetry.attach("sh-repo-handler", [:stream_heavy, :repo, :query], &StreamHeavy.Telemetry.handle_event/4, %{})
    # :ok = :telemetry.attach("ecto-logger", [:stream_heavy, :repo, :query], &StreamHeavy.EctoLogger.handle_event/4, %{})
    children = [
      # Start the Telemetry supervisor
      StreamHandlerWeb.Telemetry,
      # Start the Ecto repository
      StreamHandler.Repo,
      # StreamHandler.FinnhubClient,
      # StreamHandler.Servers.Websocket,
      # Start the PubSub system
      {Phoenix.PubSub, name: StreamHandler.PubSub},
      # Start Finch
      {Finch, name: StreamHandler.Finch},
      # Start the Endpoint (http/https)
      StreamHandlerWeb.Endpoint,
      {Nx.Serving, serving: serving, name: StreamHandler.Serving, batch_timeout: 100},
      Supervisor.child_spec({StreamHandler.Servers.Producer, [:consumer_1, []]}, id: :consumer_1),
      Supervisor.child_spec({StreamHandler.Servers.Producer, [:consumer_2, []]}, id: :consumer_2),
      Supervisor.child_spec({StreamHandler.Servers.Producer, [:consumer_3, []]}, id: :consumer_3),
      Supervisor.child_spec({StreamHandler.Servers.Producer, [:consumer_4, []]}, id: :consumer_4),
      Supervisor.child_spec({StreamHandler.Servers.Reader,    [:reader, []]}, id: :reader),
      Supervisor.child_spec({StreamHandler.Servers.Streamer,  [:streamer, []]}, id: :streamer),
      # Start a worker by calling: StreamHandler.Worker.start_link(arg)
      # {StreamHandler.Worker, arg}
      Supervisor.child_spec({StreamHandler.Servers.Message, nil}, id: :message_sup)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: StreamHandler.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    StreamHandlerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
