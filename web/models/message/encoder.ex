defmodule Shrekanography.Message.Encoder do
  use Bitwise

  def encode(message = %Shrekanography.Message{}, shrek_path \\ "priv/shreks/shrek1.png") do
    # Let's only support RGBa images for now
    {:ok, png = %Imagineer.Image.PNG{color_format: :rgb_alpha}} = Imagineer.load(shrek_path)

    encoded_pixels = encode_pixels(message.body, png.pixels)
    updated_png = %Imagineer.Image.PNG{png | pixels: encoded_pixels}
    Imagineer.Image.PNG.to_binary(updated_png)
  end

  def encode_pixels(message_body, png_pixels) do
    encode_pixels(message_body, png_pixels, [], [])
  end

  # TODO handle case when the message is longer than the number of pixels

  # Case: we haven't processed any message characters yet
  defp encode_pixels(message,
                     _remaining_pixels = [[first_pixel | remaining_row_pixels] | remaining_rows],
                     _working_row = [],
                     finished_rows = []) do

    # encode the length of the message into the first pixel
    message_length = byte_size(message) # TODO max length 256!

    encoded_pixel = encode_pixel(first_pixel, message_length)
    encode_pixels(message,
                  [remaining_row_pixels | remaining_rows],
                  [encoded_pixel],
                  finished_rows)
  end

  # Case: there aren't any pixels left to process in the current row
  defp encode_pixels(remaining_message,
                     _remaining_pixels = [[] | remaining_rows],
                     working_row,
                     finished_rows) do
    # This row is done- let's add it to the pile of processed rows and move on to the next row
    encode_pixels(remaining_message, remaining_rows, [], [Enum.reverse(working_row) | finished_rows])
  end

  # Case: no more characters in the message
  defp encode_pixels(_remaining_message = <<>>,
                     _remaining_pixels = [remaining_row_pixels | remaining_rows],
                     working_row,
                     finished_rows) do
    # Smush our placeholders together and return the encoded pixels
    current_row = Enum.reverse(working_row) ++ remaining_row_pixels
    encoded_rows = Enum.reverse([current_row | finished_rows])

    current_row_length = length(current_row)
    encoded_rows ++ remaining_rows
  end

  # General case: encode a message character into a pixel
  defp encode_pixels(_message = <<message_byte::integer, remaining_message::binary>>,
                     _remaining_pixels = [[pixel | remaining_row_pixels] | remaining_rows],
                     working_row,
                     finished_rows) do
    encoded_pixel = encode_pixel(pixel, message_byte)

    encode_pixels(remaining_message,
                  [remaining_row_pixels | remaining_rows],
                  [encoded_pixel | working_row],
                  finished_rows)
  end

  defp encode_pixel(pixel, message_byte) do
    # Stash message data in the two least significant bits of each channel.

    # Split up the message byte into four two-bit chunks:
    red_bits   = message_byte >>> 6 |> rem(4) # most significant bits...
    green_bits = message_byte >>> 4 |> rem(4)
    blue_bits  = message_byte >>> 2 |> rem(4)
    alpha_bits = message_byte       |> rem(4) # ... down to the least.

    # Then set the least significant bits of the pixel accordingly
    { set_least_significant_bits(elem(pixel, 0), red_bits),
      set_least_significant_bits(elem(pixel, 1), green_bits),
      set_least_significant_bits(elem(pixel, 2), blue_bits),
      set_least_significant_bits(elem(pixel, 3), alpha_bits) }
  end

  defp set_least_significant_bits(byte, bits_to_set) do
    byte
      &&& 0b11111100 # Clear out the two least significant bits...
      ||| bits_to_set # and replace them with the desired bits.
  end
end
