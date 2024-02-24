defmodule SpamDetect do
  use Ecto.Schema
  use Instructor.Validator

  @doc """
  ## Field Descriptions:
  - class: Whether or not the email is spam.
  - reason: A short, less than 10 word rationalization for the classification.
  - score: A confidence score between 0.0 and 1.0 for the classification.
  """
  @primary_key false
  embedded_schema do
    field(:class, Ecto.Enum, values: [:spam, :not_spam])
    field(:reason, :string)
    field(:score, :float)
  end

  @impl true
  def validate_changeset(changeset) do
    changeset
    |> Ecto.Changeset.validate_number(:score,
      greater_than_or_equal_to: 0.0,
      less_than_or_equal_to: 1.0
    )
  end

  def config do
    [api_key: System.get_env("OPENAI_API_KEY"), api_url: "https://api.openai.com", http_options: [receive_timeout: 60000]]
  end

  def is_spam?(text) do
  # is_spam? = fn text ->
    Instructor.chat_completion([
        model: "gpt-3.5-turbo",
        response_model: SpamDetect,
        max_retries: 3,
        messages: [
          %{
            role: "user",
            content: """
            Your purpose is to classify customer support emails as either spam or not.
            This is for a clothing retail business.
            They sell all types of clothing.

            Classify the following email:
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
