defmodule Politician do
  use Ecto.Schema
  use Instructor.Validator

  @doc"""
    A description of US politicians and offices they hold
    ## Fields
    - first_name: First name
    - last_name: Last name
    - offices_held
      - office: Branch and position
      - from_date # When entered
      - until_date # When left
  """
  @primary_key false
  embedded_schema do
    field(:first_name, :string)
    field(:last_name, :string)

    embeds_many :offices_held, Office, primary_key: false do
      field(:office, Ecto.Enum,
        values: [:president, :vice_president, :governor, :congress, :senate]
      )
      field(:from_date, :date)
      field(:to_date, :date)
    end
  end
end
