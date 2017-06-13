defmodule Shrekanography.Message.Encoder.Test do
  alias Shrekanography.Message.Encoder
  use ExUnit.Case, async: true

  test "encode_pixels/2 encodes the length of the message into the first two pixels" do
    pixels = [
      [
        {0b000000_00, 0b000000_01, 0b000000_10, 0b000000_11},
        {0b000000_00, 0b000000_01, 0b000000_10, 0b000000_11},
      ]
    ]
    message = "1"

    expected_first_pixel =
        {0b000000_00, 0b000000_00, 0b000000_00, 0b000000_00}
    # The last two bits of each channel combine to make 0b00000001 == 1
    expected_second_pixel =
        {0b000000_00, 0b000000_00, 0b000000_00, 0b000000_01}

    [actual_first_pixel, actual_second_pixel] =
      Encoder.encode_pixels(message, pixels)
      |> hd() # Get first row...
      |> Enum.take(2) # and first two pixels

    assert actual_first_pixel == expected_first_pixel
    assert actual_second_pixel == expected_second_pixel
  end

  test "encode_pixels/2 encodes a byte of each message into subsequent pixels, leaving extra pixels unchanged" do
    pixels = [
      [
        {0b000000_00, 0b000000_01, 0b000000_10, 0b000000_11}, # length
        {0b010000_00, 0b010000_01, 0b010000_10, 0b010000_11}  # length
      ], [
        {0b100000_00, 0b100000_01, 0b100000_10, 0b100000_11}, # first message
        {0b110000_00, 0b110000_01, 0b110000_10, 0b110000_11}  # second message
      ]
    ]
    message = <<0b11_10_01_00, 0b10_01_10_01>>

    expected_first_message_pixel =
        {0b100000_11, 0b100000_10, 0b100000_01, 0b100000_00}
    expected_second_message_pixel =
        {0b110000_10, 0b110000_01, 0b110000_10, 0b110000_01}

    [[_length_pixel, _another_length_pixel],
     [actual_first_message_pixel, actual_second_message_pixel]] = Encoder.encode_pixels(message, pixels)

    assert actual_first_message_pixel == expected_first_message_pixel
    assert actual_second_message_pixel == expected_second_message_pixel
  end

end
