defmodule Shrekanography.DecodingController do
  use Shrekanography.Web, :controller
  alias Shrekanography.Message

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"secret" => %{"image" => upload}}) do
    message = Message.decode(upload.path)
    render conn, "show.html", message: message
  end
end
