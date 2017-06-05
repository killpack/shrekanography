defmodule Shrekanography.Message do
  alias Shrekanography.Message

  defstruct [body: nil, shrek_filename: nil]

  def encode(message = %Message{}) do
    Message.Encoder.encode(message.body, message.shrek_filename)
  end

  def decode(file_path) do
    body = Message.Decoder.decode(file_path)
    %Message{body: body}
  end
end
