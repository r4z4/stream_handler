defmodule StreamHandler.Servers.Message do
  alias StreamHandler.Repo
  alias StreamHandler.Message

  @time_interval_ms 2000
  @file_path "./files/"

  @impl true
  def start_link() do
    # IO.inspect(state, label: "Starting Message Sup")
    children = Enum.map([:a,:b,:c,:d,:e], &worker_spec/1)
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  @impl true
  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end

  defp worker_spec(worker_id) do
    initial_worker_spec = {Message.MessageWorker, {@file_path, worker_id}}
    Supervisor.child_spec(initial_worker_spec, id: worker_id)
  end

  def get_worker() do
    :rand.uniform(5)
  end

  def save(store_name, data) do
    Message.MessageWorker.save(get_worker(), store_name, data)
  end

  def fetch(store_name) do
    Message.MessageWorker.fetch(get_worker(), store_name)
  end
end
