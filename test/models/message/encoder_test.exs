defmodule Shrekanography.Message.Encoder.Test do
  alias Shrekanography.Message.Encoder
  use ExUnit.Case, async: true

  test "encode_pixels/2 encodes the length of the message into the first pixel" do
    pixels = [
      [
        {0b000000_00, 0b000000_01, 0b000000_10, 0b000000_11},
        {0, 0, 0, 0} # Doesn't matter here
      ]
    ]
    message = "1"

    # The last two bits of each channel combine to make 0b00000001 == 1
    expected_encoded_length_pixel =
        {0b000000_00, 0b000000_00, 0b000000_00, 0b000000_01}

    actual_encoded_length_pixel =
      Encoder.encode_pixels(message, pixels)
      |> hd() # Get first row...
      |> hd() # and first pixel
    assert actual_encoded_length_pixel == expected_encoded_length_pixel
  end

  test "encode_pixels/2 encodes a byte of each message into subsequent pixels, leaving extra pixels unchanged" do
    pixels = [
      [
        {0b000000_00, 0b000000_01, 0b000000_10, 0b000000_11}, # length
        {0b010000_00, 0b010000_01, 0b010000_10, 0b010000_11}  # first message
      ], [
        {0b100000_00, 0b100000_01, 0b100000_10, 0b100000_11}, # second message
        {0b110000_00, 0b110000_01, 0b110000_10, 0b110000_11}  # unchanged
      ]
    ]
    message = <<0b11_10_01_00, 0b10_01_10_01>>

    expected_first_message_pixel =  {0b010000_11, 0b010000_10, 0b010000_01, 0b010000_00}
    expected_second_message_pixel = {0b100000_10, 0b100000_01, 0b100000_10, 0b100000_01}

    [[_length_pixel, actual_first_message_pixel],
     [actual_second_message_pixel, leftover_pixel]] = Encoder.encode_pixels(message, pixels)

    assert actual_first_message_pixel == expected_first_message_pixel
    assert actual_second_message_pixel == expected_second_message_pixel
    assert leftover_pixel == pixels |> Enum.at(1) |> Enum.at(1)
  end

end
