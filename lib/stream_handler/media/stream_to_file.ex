defmodule StreamHandler.Media.StreamToFile do
  use Membrane.Pipeline

  alias Membrane.PortAudio
  alias Membrane.Audiometer.Peakmeter
  alias Membrane.Element.Fake

  @impl true
  def handle_init(output_directory) do
    Elixir.File.mkdir_p!(output_directory)
    Process.register(self(), :default_stream)

    # children = [
    #   mic_input: PortAudio.Source,
    #   audiometer: %Peakmeter{interval: Membrane.Time.milliseconds(50)},
    #   sink: Fake.Sink.Buffers
    # ]

    # links = [
    #   link(:mic_input) |> to(:audiometer) |> to(:sink)
    # ]

    structure = [
        child(:mic_input, PortAudio.Source),
        child(:audiometer, %Peakmeter{interval: Membrane.Time.milliseconds(50)}),
        child(:sink, Fake.Sink.Buffers),
        get_child(:mic_input) |> get_child(:audiometer) |> get_child(:sink)
      ]


    # {{:ok, spec: %ParentSpec{children: children, links: links}}, %{}}
    spec = {structure, crash_group: {:first_group, :temporary}}
    {[spec: spec], %{}}
  end

  @impl true
  def handle_notification({:amplitudes, channels}, _element, _context, state) do
    IO.inspect(channels, label: "amplitude")
    Phoenix.PubSub.broadcast!(StreamHandler.PubSub, "audio", {:amplitudes, channels})
    {:ok, state}
  end

  def handle_notification(_any, _element, _context, state) do
    {:ok, state}
  end
end
