defmodule StreamHandler.System do
  use Supervisor

  def start do
    Supervisor.start_link(__MODULE__, nil)
  end

  def init(_) do
    Supervisor.init([StreamHandler.Servers.Message], strategy: :one_for_one)
  end
end
