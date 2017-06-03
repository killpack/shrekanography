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

  defp decode_pixel(pixel) do
    red_bits   = elem(pixel, 0) &&& 0b11 # only take the two least significant bits
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
