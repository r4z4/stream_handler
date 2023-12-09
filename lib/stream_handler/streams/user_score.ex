defmodule StreamHandler.Streams.UserScore do
  use Ecto.Schema
  import Ecto.Changeset
  # alias EmerPhx.Core.Utils

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "user_score" do
    field :username, :string
    field :score, :integer
    field :joined, :naive_datetime
    # field :type, Ecto.Enum, values: Utils.attachment_types

    timestamps()
  end

  @doc false
  def changeset(attachments, attrs) do
    attachments
    |> cast(attrs, [:title, :path, :data])
    |> validate_required([:title, :path, :data])
  end
end
