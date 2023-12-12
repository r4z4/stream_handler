defmodule StreamHandler.Streams.UserMessage do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "user_score" do
    field :user_id, :string
    field :type, :integer
    field :from, :integer
    field :path, :string
    # field :type, Ecto.Enum, values: Utils.attachment_types

    timestamps()
  end

  @doc false
  def changeset(attachments, attrs) do
    attachments
    |> cast(attrs, [:user_id, :type, :from, :path])
    |> validate_required([:user_id, :type, :from, :path])
  end
end
