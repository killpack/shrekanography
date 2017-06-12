defmodule Shrekanography.Message.Decoder do
  use Bitwise

  def decode(file_path) do
    {:ok, png} = Imagineer.load(file_path)

    decode_pixels(png.pixels)
  end

  def decode_pixels(pixels) do
    [first_pixel | remaining_pixels] = List.flatten(pixels)
    message_length = decode_pixel(first_pixel)

    message_pixels = Enum.take(remaining_pixels, message_length)

    chars = for pixel <- message_pixels, do: decode_pixel(pixel)
    :erlang.list_to_binary(chars)
  end

  defp decode_pixel({red, green, blue, alpha}) do
    red_bits   = red   &&& 0b11 # only take the two least significant bits
    green_bits = green &&& 0b11
    blue_bits  = blue  &&& 0b11
    alpha_bits = alpha &&& 0b11
    character =
      (red_bits   <<< 6) +
      (green_bits <<< 4) +
      (blue_bits  <<< 2) +
      alpha_bits
    character
  end

end
