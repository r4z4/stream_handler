defmodule StreamHandler.Media.AudioChunk do
  # defstruct [:id, :building_number , :city, :city_prefix, :city_suffix, :community, :country, :country_code, :full_address, :latitude, :longitude,
  # :mail_box, :postcode, :secondary_address, :state, :state_abbr, :street_address, :street_name, :street_suffix, :time_zone, :uid, :zip, :zip_code]
  use Ecto.Schema
  alias StreamHandler.Core.Utils
  alias StreamHandler.Core.Error
  alias __MODULE__

  @primary_key false
  schema "audio_chunk" do
    field :text, :string
    field :start_timestamp_seconds, :float
    field :end_timestamp_seconds, :float
  end

  @spec validate_required_fields({:map, ErrorList}) :: {arg1, arg2} when arg1: :map, arg2: ErrorList
  defp validate_required_fields({object, err_props}) do
    IO.inspect(object)
    required_fields = [:text]
    missing = Enum.map(required_fields, fn field ->
      res = Map.fetch(object, field)
      # IO.inspect(res, label: "Res")
      case res do
        {:ok, nil} -> field
        {:ok, _val} -> nil
        :error -> field
        _ -> field
      end
    end)
    # IO.inspect(missing, label: "Missing")
    case Enum.any?(missing) do
      false -> {:ok, {object, err_props}}
      true  ->
        err_props = Map.replace(err_props, :errors, [%Error{type: :validation, text: "Missing Fields: #{Utils.display_missing_fields(missing)}"} | err_props.errors])
        {:error, {object, err_props}}
    end
  end

  @spec validate_text({:map, ErrorList}) :: {arg1, arg2} when arg1: :map, arg2: ErrorList
  defp validate_text({object, err_props}) do
    text = object[:text]
    # valid = String.match?(url, pattern)
    valid = true
    case valid do
      true -> {object, err_props}
      false ->
        err_props = Map.replace(err_props, :errors, [%Error{type: :validation, text: "Invalid Name"} | err_props.errors])
        {object, err_props}
    end
  end

  def new(object) do
    err_props = %{:errors => []}
    valid =
      case validate_required_fields({object, err_props}) do
        # Only further validate if the fields are present. Avoids a nil check in each.
        {:ok, {object, err_props}} ->
          {object, err_props}
          |> validate_text()
          # |> validate_population()
        {:error, {object, err_props}} ->
          {object, err_props}
      end

    err_props = Kernel.elem(valid, 1)

    case List.first(err_props.errors) do
      # No errors, create Struct
      nil ->
        %AudioChunk{
          text: object[:text],
          start_timestamp_seconds: object[:start_timestamp_seconds],
          end_timestamp_seconds: object[:end_timestamp_seconds],
        }
      # Return errors if errors in the error list
      _ -> err_props.errors

    end
  end
end
