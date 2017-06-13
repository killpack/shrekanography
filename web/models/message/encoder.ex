defmodule Shrekanography.Message.Encoder do
  use Bitwise

  def encode(message_body, shrek_filename) do
    {shrek_filename, png} = Shrekanography.PngServer.fetch_png(shrek_filename)

    encoded_pixels = encode_pixels(message_body, png.pixels)

    png_binary = %Imagineer.Image.PNG{png | pixels: encoded_pixels} |> Imagineer.Image.PNG.to_binary
    {shrek_filename, png_binary}
  end

  def encode_pixels(message_body, png_pixels) do
    # Stash the length of the message into the first two pixels
    message_length = byte_size(message_body)
    full_message = :erlang.binary_to_list(<<message_length::size(16), message_body::binary>>)

    row_length = length(hd(png_pixels))

    {pixels_to_encode, leftover_pixels} = png_pixels |> List.flatten |> Enum.split(message_length + 2) # to account for the two bytes that hold the length

    encoded_pixels = Enum.zip(pixels_to_encode, full_message) |> Enum.map(&encode_pixel/1)

    (encoded_pixels ++ leftover_pixels) |> Enum.chunk(row_length)
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
