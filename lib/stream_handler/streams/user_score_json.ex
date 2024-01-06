defmodule StreamHandler.Streams.UserScoreJson do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "user_score_json" do
    field :user_scores, :map
    # embeds_one :user_scores_object, UserScoresObject, source: :user_scores
    field :inserted_at, :naive_datetime
  end

  @doc false
  def changeset(user_score_json, attrs) do
    user_score_json
    |> cast(attrs, [:user_scores, :inserted_at])
    |> validate_required([:user_scores, :inserted_at])
  end
end

# defmodule StreamHandler.Streams.UserScoreJson do
#   use Ecto.Schema
#   import Ecto.Changeset

#   @primary_key false
#   embedded_schema do
#     field :user_scores, :map
#     field :inserted_at, :naive_datetime
#   end

#   @doc false
#   def changeset(scores, attrs) do
#     scores
#     |> cast(attrs, [:user_scores, :inserted_at])
#     |> validate_required([])
#   end
# end
