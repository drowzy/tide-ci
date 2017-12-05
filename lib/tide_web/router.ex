defmodule TideWeb.Router do
  use TideWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api/v1", TideWeb do
    pipe_through(:api)

    resources "/hosts", HostController do
      put("/connect", HostController, :connect)
      put("/disconnect", HostController, :disconnect)
    end

    resources "/projects", ProjectController do
      resources("/jobs", JobController)
    end
  end
end
