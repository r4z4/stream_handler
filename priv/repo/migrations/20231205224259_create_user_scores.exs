defmodule EmerPhx.Repo.Migrations.CreateUserScore do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:user_score, primary_key: false) do
      add :id, :binary_id, primary_key: true
      # add :email, :citext, null: false
      add :username, :string, null: false
      add :score, :integer, null: false
      add :joined, :naive_datetime
      timestamps(null: [:updated_at])
    end

    create unique_index(:user_score, [:username])

  end
end
