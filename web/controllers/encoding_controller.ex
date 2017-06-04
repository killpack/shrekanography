defmodule Shrekanography.EncodingController do
  use Shrekanography.Web, :controller
  alias Shrekanography.Message

  @output_filename "secret_shrek.png"

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"message" => %{"body" => body}}) do
    message = %Message{body: body}
    body = Message.encode(message)
    conn
      |> put_resp_content_type("image/png")
      |> put_resp_header("Content-Disposition", "attachment;filename=#{@output_filename}")
      |> send_resp(200, body)
  end
end
