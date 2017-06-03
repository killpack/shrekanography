defmodule Shrekanography.EncodingController do
  use Shrekanography.Web, :controller
  alias Shrekanography.Message

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"message" => %{"body" => body}}) do
    message = %Message{body: body}
    filename = "secret_shrek.png"
    body = Message.encode(message)
    conn
      |> put_resp_content_type("image/png")
      |> put_resp_header("Content-Disposition", "attachment;filename=#{filename}")
      |> send_resp(200, body)
  end
end
