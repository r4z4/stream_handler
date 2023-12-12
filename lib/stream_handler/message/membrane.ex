defmodule StreamHandler.Message.Membrane do
  use Membrane.Pipeline
  alias Membrane.FFmpeg.SWResample.Converter
  alias Membrane.{File, RawAudio}

  @impl true
  def handle_init(_ctx, mp3_url) do
    spec =
      child(%Membrane.Hackney.Source{
        location: mp3_url, hackney_opts: [follow_redirect: true]
      })
      |> child(Membrane.MP3.MAD.Decoder)
      |> child(Membrane.PortAudio.Sink)

    {[spec: spec], %{}}
  end

  # @impl true
  # def handle_init(_ctx, _opts) do
  #   structure = [
  #     child(:file_src, %File.Source{location: "/tmp/elixir_converted_from_twilio.pcm"})
  #     |> child(:converter, %Converter{
  #       input_stream_format: %RawAudio{channels: 1, sample_format: :s8le, sample_rate: 8_000},
  #       output_stream_format: %RawAudio{channels: 1, sample_format: :f32le, sample_rate: 16_000}
  #     })
  #     |> child(:file_sink, %File.Sink{location: "/tmp/elixir_converted_from_twilio_16khz_f32.pcm"})
  #   ]

  #   {[spec: structure, playback: :playing], nil}
  # end

  @impl true
  def handle_element_end_of_stream(:file_sink, _pad, _ctx_, _state) do
    {[playback: :stopped], nil}
  end

  def convert_audio(binary) do
    new =
        child(binary)
        |> child(:converter, %Converter{
          input_stream_format: %RawAudio{channels: 1, sample_format: :s8le, sample_rate: 8_000},
          output_stream_format: %RawAudio{channels: 1, sample_format: :f32le, sample_rate: 16_000}
        })
    # |> child(:file_sink, %File.Sink{location: "/files/blouse.mp3"})

    new
  end
end
