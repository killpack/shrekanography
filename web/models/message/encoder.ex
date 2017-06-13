defmodule Shrekanography.Message.Encoder do
  use Bitwise

  def encode(message_body, shrek_filename) do
    {shrek_filename, png} = Shrekanography.PngServer.fetch_png(shrek_filename)

    encoded_pixels = encode_pixels(message_body, png.pixels)

    png_binary = %Imagineer.Image.PNG{png | pixels: encoded_pixels} |> Imagineer.Image.PNG.to_binary
    {shrek_filename, png_binary}
  end

  def encode_pixels(message_body, png_pixels) do
    # Stash the length of the message into the first pixel
    message_length = byte_size(message_body) |> :binary.encode_unsigned(:big)

    encode_rows(message_length <> message_body, png_pixels, [])
  end

  defp encode_rows(_remaining_message = <<>>,
                   _remaining_rows = [],
                   finished_rows) do
    Enum.reverse(finished_rows)
  end

  defp encode_rows(message,
                   [current_row | remaining_rows],
                   finished_rows) do
    bytes_to_take = min(length(current_row), byte_size(message))

    <<current_message::binary-size(bytes_to_take), remaining_message::binary>> = message

    encoded_row = encode_row(current_message, current_row)
    encode_rows(remaining_message, remaining_rows, [encoded_row | finished_rows])
  end

  def encode_row(message, row) do
    {pixels_to_encode, leftover_pixels} = Enum.split(row, byte_size(message))
    message_as_list = :erlang.binary_to_list(message)

    encoded_pixels = Enum.zip(pixels_to_encode, message_as_list) |> Enum.map(&encode_pixel/1)
    encoded_pixels ++ leftover_pixels
  end

  defp encode_pixel({{red, green, blue, alpha}, message_byte}) do
    # Stash message data in the two least significant bits of each channel.

    # Split up the message byte into four two-bit chunks:
    red_bits   = message_byte >>> 6 &&& 0b11 # two most significant bits...
    green_bits = message_byte >>> 4 &&& 0b11
    blue_bits  = message_byte >>> 2 &&& 0b11
    alpha_bits = message_byte       &&& 0b11 # ... down to the least.

    # Then set the least significant bits of the pixel accordingly
    { set_least_significant_bits(red, red_bits),
      set_least_significant_bits(green, green_bits),
      set_least_significant_bits(blue, blue_bits),
      set_least_significant_bits(alpha, alpha_bits) }
  end

  defp set_least_significant_bits(byte, bits_to_set) do
    byte
      &&& 0b11111100 # Clear out the two least significant bits...
      ||| bits_to_set # and replace them with the desired bits.
  end
end
