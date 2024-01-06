defmodule StreamHandler.Media.AudioChunkList do
  use Ecto.Schema
  use Ecto.Type
  alias StreamHandler.Media.AudioChunk
  alias __MODULE__

  def type, do: :array

  schema "audio_chunk_list" do
    embeds_many(:chunks, AudioChunk)
  end

  def empty?(chunk_list = %AudioChunkList{chunks: _}) do
    case List.first(chunk_list.chunks) do
      nil -> true
      _   -> false
    end
  end

  def new_from_list(list) do
    Enum.map(list, fn ac -> AudioChunk.new(ac) end)
  end

  def new_from_obj(obj) do
    # IO.inspect(obj, label: "Obj")
    list = Enum.map(obj.chunks, fn ac -> AudioChunk.new(ac) end)
    # IO.inspect(list, label: "List")
    %AudioChunkList{chunks: list}
  end
end
