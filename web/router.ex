defmodule Shrekanography.Router do
  use Shrekanography.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", Shrekanography do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/encode", EncodingController, :new
    post "/encode", EncodingController, :create
    get "/decode", DecodingController, :new
    post "/decode", DecodingController, :create
  end
end
