defmodule Shrekanography.Message do
  alias Shrekanography.Message
  use Bitwise

  defstruct [body: nil]
  ## TODO message length- encode in first pixel

  def encode(message = %Message{}, shrek_path \\ "priv/shreks/shrek1.png") do
    # Let's only support RGBa images for now
    {:ok, png = %Imagineer.Image.PNG{color_format: :rgb_alpha}} = Imagineer.load(shrek_path)

    encoded_pixels = do_encode(message.body, png.pixels, [], [])
    updated_png = %Imagineer.Image.PNG{png | pixels: encoded_pixels}
    Imagineer.Image.PNG.to_binary(updated_png)
  end

  def decode(shrek_path \\ "priv/shreks/secret_shrek.png") do
    {:ok, png} = Imagineer.load(shrek_path)

    decoded_message = do_decode(png.pixels)
  end


  defp do_encode(message, [[first_pixel | remaining_row_pixels] | remaining_rows], [], []) do
    # Encode the length of the message in the first pixel
    message_length = byte_size(message)
    encoded_pixel = encode_pixel(first_pixel, message_length)
    do_encode(message, [remaining_row_pixels | remaining_rows], [encoded_pixel], [])
  end
  defp do_encode(message, [[] | [next_row | remaining_rows]], in_progress_row, finished_rows) do
    # This row is done- let's add it to the pile and move on to the next row
    IO.puts("ran out of rows")
    do_encode(message, next_row, [], [in_progress_row | finished_rows])
  end
  defp do_encode(<<>>, [remaining_row_pixels | remaining_rows], in_progress_row, finished_rows) do
    # No more characters in the message- finish up
    current_row = Enum.reverse(in_progress_row) ++ remaining_row_pixels
    encoded_rows = Enum.reverse(finished_rows) ++ current_row
    [encoded_rows] ++ remaining_rows
  end
  defp do_encode(<<message_byte::integer, remaining_message::binary>>,
                 [[pixel | remaining_row_pixels] | remaining_rows],
                 in_progress_row,
                 finished_rows) do
    encoded_pixel = encode_pixel(pixel, message_byte)

    do_encode(remaining_message,
              [remaining_row_pixels | remaining_rows],
              [encoded_pixel | in_progress_row],
              finished_rows)
  end

  defp encode_pixel(pixel, message_byte) do
    red_bits   = message_byte >>> 6 |> rem(4) # most significant bits...
    green_bits = message_byte >>> 4 |> rem(4)
    blue_bits  = message_byte >>> 2 |> rem(4)
    alpha_bits = message_byte       |> rem(4) # ... down to the least.

    { set_least_significant_bits(elem(pixel, 0), red_bits),
      set_least_significant_bits(elem(pixel, 1), green_bits),
      set_least_significant_bits(elem(pixel, 2), blue_bits),
      set_least_significant_bits(elem(pixel, 3), alpha_bits)}
  end

  defp set_least_significant_bits(byte, bits_to_set) do
    byte
      &&& 0b11111100 # Clear out the two least significant bits...
      ||| bits_to_set # and replace them with the desired bits.
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
