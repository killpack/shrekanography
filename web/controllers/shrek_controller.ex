defmodule Shrekanography.ShrekController do
  use Shrekanography.Web, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"shrek" => shrek_params}) do
    render conn, "new.html"
  end
end
