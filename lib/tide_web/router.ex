defmodule TideWeb.Router do
  use TideWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", TideWeb do
    pipe_through :api

    resources "/hosts", HostsController
  end
end
