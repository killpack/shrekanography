defmodule Shrekanography.EncodingController do
  use Shrekanography.Web, :controller
  alias Shrekanography.Message

  @output_filename "secret_shrek.png"

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"message" => message_params, "download" => "true"}) do
    message = message_from_params(message_params)
    {_shrek_filename, png_binary} = Message.encode(message)

    conn
      |> put_resp_content_type("image/png")
      |> put_resp_header("Content-Disposition", "attachment;filename=#{@output_filename}")
      |> send_resp(200, png_binary)
  end

  def create(conn, %{"message" => message_params}) do
    message = message_from_params(message_params)
    {shrek_filename, png_binary} = Message.encode(message)

    message = %{ message | shrek_filename: shrek_filename }

    render conn, "show.html", png_binary: png_binary, message: message
  end

  defp message_from_params(message_params) do
    %Message{body: message_params["body"], shrek_filename: message_params["shrek_filename"]}
  end
end
