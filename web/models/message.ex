defmodule Shrekanography.Message do
  alias Shrekanography.Message
  use Bitwise

  defstruct [body: nil]
  ## TODO message length- encode in first pixel

  def encode(message) do
    Message.Encoder.encode(message)
  end

  def decode(shrek_path \\ "priv/shreks/secret_shrek.png") do
    {:ok, png} = Imagineer.load(shrek_path)

    do_decode(png.pixels)
  end

  defp do_decode(pixels) do
    [first_pixel | remaining_pixels] = List.flatten(pixels)
    message_length = decode_pixel(first_pixel)

    message_pixels = Enum.take(remaining_pixels, message_length)
    chars = for pixel <- message_pixels, do: decode_pixel(pixel)
    :erlang.list_to_binary(chars)
  end

  defp decode_pixel(pixel) do
    red_bits   = elem(pixel, 0) &&& 0b11
    green_bits = elem(pixel, 1) &&& 0b11
    blue_bits  = elem(pixel, 2) &&& 0b11
    alpha_bits = elem(pixel, 3) &&& 0b11
    character =
      (red_bits   <<< 6) +
      (green_bits <<< 4) +
      (blue_bits  <<< 2) +
      alpha_bits
    character
  end
end
