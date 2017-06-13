defmodule Shrekanography.Message.Decoder do

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
    <<_::size(6), red_bits::size(2)>>   = <<red>>
    <<_::size(6), green_bits::size(2)>> = <<green>>
    <<_::size(6), blue_bits::size(2)>>  = <<blue>>
    <<_::size(6), alpha_bits::size(2)>> = <<alpha>>

    character = <<red_bits::size(2), green_bits::size(2), blue_bits::size(2), alpha_bits::size(2)>>
    character |> :binary.decode_unsigned(:big)
  end

end
