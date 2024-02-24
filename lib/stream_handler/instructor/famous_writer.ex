defmodule FamousWriter do
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
    field(:name, :string)
    field(:style, :string)
    field(:descriptors, {:array, :string})
  end

  @impl true
  def validate_changeset(changeset) do
    changeset
    |> Ecto.Changeset.validate_length(:style,
      min: 3, max: 40
    )
  end

  def config do
    [api_key: System.get_env("OPENAI_API_KEY"), api_url: "https://api.openai.com", http_options: [receive_timeout: 60000]]
  end

  def find_similar?(text) do
    # is_spam? = fn text ->
      Instructor.chat_completion([
          model: "gpt-3.5-turbo",
          response_model: FamousWriter,
          max_retries: 3,
          messages: [
            %{
              role: "user",
              content: """
              Your purpose is to classify writing samples and determine the closest famous author that the writing style resembles.
              This is for beginning writers who are thinking about their strengths and influences.
              Focus mostly on the overall theme of the writing sample.

              Which famous author is most likely to have written the following writing sample:
              ```
              #{text}
              ```
              """
            }
          ]
        ],
        SpamDetect.config()
      )
    end
end
