defmodule StreamHandler.Repo.Migrations.CreateAddress do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:address, primary_key: true) do
      # Adding a custom field here to group in DB. Each round will have an ID. UUID
      add :round_id, :string
      add :building_number, :string
      add :city, :string
      add :city_prefix, :string
      add :city_suffix, :string
      add :community, :string
      add :country, :string
      add :country_code, :string
      add :full_address, :string
      add :latitude, :float
      add :longitude, :float
      add :mail_box, :string
      add :postcode, :string
      add :secondary_address, :string
      add :state, :string
      add :state_abbr, :string
      add :street_address, :string
      add :street_name, :string
      add :street_suffix, :string
      add :time_zone, :string
      add :uid, :string
      add :zip, :string
      add :zip_code, :string
    end
    create unique_index(:address, [:id])
  end
end
