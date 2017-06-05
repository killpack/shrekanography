defmodule Shrekanography.EncodingController do
  use Shrekanography.Web, :controller
  alias Shrekanography.Message

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"message" => %{"body" => body}}) do
    message = %Message{body: body}
    png_binary = Message.encode(message)

    render conn, "show.html", png_binary: png_binary
  end
end
