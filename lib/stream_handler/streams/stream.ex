defmodule StreamHandler.Streams.Stream do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stream" do
    field :data, :binary
    field :desc, :string

    timestamps()
  end

  @doc false
  def changeset(stream, attrs) do
    stream
    |> cast(attrs, [:id, :desc, :data])
    |> validate_required([:id, :desc, :data])
  end
end
