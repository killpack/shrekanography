# Shrekanography

Steganography is when you embed a secret message in an otherwise-innocuous file.

*Shrekanography* is when you do that, but with a picture of Shrek.

This project embeds a message byte-by-byte into a PNG.
There are four channels in a PNG- red, green, blue, and alpha.
Depending on the PNG, that means there are four bytes per pixel.
So, for each byte of message data, we split it up into four chunks, and replace the least significant two bits of each pixel channel with a chunk of the message byte.
Using the two least significant bits means that the human eye won't be able to distinguish between the resulting image and the original- there's a maximum change of about 1% per channel on each pixel.

Plus, you get to look at that great picture of Shrek.

## Limitations
Currently, messages are limited to 255 bytes.
This is because we're encoding the length of the message into the first pixel, and an unsigned byte can only contain a maximum value of 255.

## Here is some generic Phoenix stuff that it spat out when I created a new app
To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

