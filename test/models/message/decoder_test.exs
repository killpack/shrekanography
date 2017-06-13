defmodule Shrekanography.Message.Decoder.Test do
  alias Shrekanography.Message.Decoder
  use ExUnit.Case, async: true

  test "decode_pixels/2 undoes Encoder.encode_pixels/2" do
    {:ok, png} = Imagineer.load("priv/shreks/shrek1.png")
    message = """
      Here's a pretty long message. Nice.
      It's got unicode characters, too. よし！
      Hooray for messages!
      """ |> String.duplicate(50)
    encoded_pixels = Shrekanography.Message.Encoder.encode_pixels(message, png.pixels)
    decoded_message = Decoder.decode_pixels(encoded_pixels)

    assert decoded_message === message
  end
end
