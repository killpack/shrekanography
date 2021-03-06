defmodule Shrekanography.Message.Encoder do

  def encode(message_body, shrek_filename) do
    {shrek_filename, png} = Shrekanography.PngServer.fetch_png(shrek_filename)

    encoded_pixels = encode_pixels(message_body, png.pixels)

    png_binary = %Imagineer.Image.PNG{png | pixels: encoded_pixels} |> Imagineer.Image.PNG.to_binary
    {shrek_filename, png_binary}
  end

  def encode_pixels(message_body, png_pixels) do
    # Stash the length of the message into the first pixel
    message_length = byte_size(message_body)
    full_message = [message_length | :erlang.binary_to_list(message_body)]

    row_length = length(hd(png_pixels))

    {pixels_to_encode, leftover_pixels} = png_pixels |> List.flatten |> Enum.split(message_length + 1)

    encoded_pixels = Enum.zip(pixels_to_encode, full_message) |> Enum.map(&encode_pixel/1)

    (encoded_pixels ++ leftover_pixels) |> Enum.chunk(row_length)
  end

  defp encode_pixel({{red, green, blue, alpha}, message_byte}) do
    # Stash message data in the two least significant bits of each channel.

    # Split up the message byte into four two-bit chunks:
    <<red_bits::size(2), green_bits::size(2), blue_bits::size(2), alpha_bits::size(2)>> = <<message_byte>>

    # Then set the least significant bits of the pixel accordingly
    { set_last_two_bits(red, red_bits),
      set_last_two_bits(green, green_bits),
      set_last_two_bits(blue, blue_bits),
      set_last_two_bits(alpha, alpha_bits) }
  end

  defp set_last_two_bits(byte, bits_to_set) do
    <<first_six_bits::size(6), _last_two_bits::size(2)>> = <<byte>>
    <<first_six_bits::size(6), bits_to_set::size(2)>> |> :binary.decode_unsigned(:big)
  end
end
