defmodule StreamHandler.Repo do
  use Ecto.Repo,
    otp_app: :stream_handler,
    adapter: Ecto.Adapters.Postgres
end
