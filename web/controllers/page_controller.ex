defmodule Shrekanography.PageController do
  use Shrekanography.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
