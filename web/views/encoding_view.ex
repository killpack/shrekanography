defmodule Shrekanography.EncodingView do
  use Shrekanography.Web, :view

  def encoded_image(png_binary) do
    base64_image = Base.encode64(png_binary)
    data_url = "data:image/png;base64," <> base64_image
    link to: data_url, download: "secret_shrek.png" do
      img_tag(data_url)
    end
  end
end
