defmodule EmerPhx.Repo.Migrations.CreateUserScoreJson do
  use Ecto.Migration

  def change do
    create table(:user_score_json, primary_key: true) do
      add :user_scores, :jsonb
      add :inserted_at, :naive_datetime
    end

    create unique_index(:user_score_json, [:id])
    execute("CREATE INDEX IF NOT EXISTS user_score_json_index ON user_score_json USING GIN(user_scores)")
  end
end
