defmodule StreamHandler.Entities.Address do
  # defstruct [:id, :building_number , :city, :city_prefix, :city_suffix, :community, :country, :country_code, :full_address, :latitude, :longitude,
  # :mail_box, :postcode, :secondary_address, :state, :state_abbr, :street_address, :street_name, :street_suffix, :time_zone, :uid, :zip, :zip_code]
  use Ecto.Schema

  @primary_key {:id, :integer, autogenerate: false}
  schema "address" do
    field :round_id, :string
    field :building_number, :string
    field :city, :string
    field :city_prefix, :string
    field :city_suffix, :string
    field :community, :string
    field :country, :string
    field :country_code, :string
    field :full_address, :string
    field :latitude, :float
    field :longitude, :float
    field :mail_box, :string
    field :postcode, :string
    field :secondary_address, :string
    field :state, :string
    field :state_abbr, :string
    field :street_address, :string
    field :street_name, :string
    field :street_suffix, :string
    field :time_zone, :string
    field :uid, :string
    field :zip, :string
    field :zip_code, :string
  end

  # defp serialise(data) do
  #   data
  #   |> Enum.map(fn row ->
  #     [id, building_number, city, city_prefix, community, country, country_code, full_address, latitude, longitude, mail_box,
  #     postcode, secondary_address, state, state_abbr, street_address, street_name, street_suffix, time_zone, uid, zip, zip_code] = row

  #     %Address{
  #       id: id,
  #       building_number: building_number,
  #       city: city,
  #       city_prefix: city_prefix,
  #       community: community,
  #       country: country,
  #       country_code: country_code,
  #       full_address: full_address,
  #       latitude: latitude,
  #       longitude: longitude,
  #       mail_box: mail_box,
  #       postcode: postcode,
  #       secondary_address: secondary_address,
  #       state: state,
  #       state_abbr: state_abbr,
  #       street_address: street_address,
  #       street_name: street_name,
  #       street_suffix: street_suffix,
  #       time_zone: time_zone,
  #       uid: uid,
  #       zip: zip,
  #       zip_code: zip_code
  #     }
  #   end)
  # end

  # defimpl Jason.Encoder, for: Address do
  #   @impl Jason.Encoder
  #   def encode(value, opts) do
  #     {notes, remaining_log} = Map.pop(value, :notes)

  #     remaining_log
  #     |> Map.from_struct()
  #     |> Map.new(fn {k, v} -> {k, String.to_integer(v)} end)
  #     |> Map.put(:notes, notes)
  #     |> Jason.Encode.map(opts)
  #   end
  # end
end
