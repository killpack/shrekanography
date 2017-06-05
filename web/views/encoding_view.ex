defmodule Shrekanography.EncodingView do
  use Shrekanography.Web, :view

  def encoded_image(conn, message, png_binary) do
    base64_image = Base.encode64(png_binary)
    data_url = "data:image/png;base64," <> base64_image

    message_params = Map.from_struct(message)
    link to: encoding_path(conn, :create, download: "true", message: message_params), method: :post do
      img_tag(data_url)
    end
  end
end
